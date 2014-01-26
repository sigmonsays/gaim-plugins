/*
Usage:

	Create a table like so:

CREATE TABLE gaim-logs (
  id bigint(20) NOT NULL auto_increment,
  when timestamp(14) NOT NULL,
  user varchar(64) NOT NULL default '',
  from varchar(64) NOT NULL default '',
  text text NOT NULL,
  KEY id (id)
) TYPE=MyISAM;

	edit ~/.gaim/gaim-log.cfg like:
	host: localhost
	user: root
	pass: password
	database: db_name
	table: what you called the table

*/

#define GAIM_PLUGINS
#define DB_CONFIG_FILE "gaim-log.cfg"
#define FAILED_LOG "failed-logs.log"
#include "gaim.h"

#include <stdio.h>
#include <stdlib.h>
#include <gtk/gtk.h>
#include <string.h>
#include <mysql/mysql.h>
#include <sys/types.h>
#include <unistd.h>

void *phandle;
MYSQL *mysqlConnection;
char *db_table = "gaim-logs";

void chomp(char *s);
int log_to_mysql(char *user, char *who, char *what);
int log_to_file(char *s);
void log_failed();


void get_im(struct gaim_connection *gc, char **who, char **what, void *m) {
	log_to_mysql(*who, gc->username, strip_html(*what));
}

void send_im(struct gaim_connection *gc, char *who, char **what, void *m) {
	log_to_mysql(gc->username, who, strip_html(*what));
}

void gaim_plugin_remove(void) {
	mysql_close(mysqlConnection);
}

char *gaim_plugin_init(GModule *h) {
	char *p, *path, *homedir;
	char buf[1024];
	FILE *f;
	char *db_host = "localhost", *db_user = "root", *db_pass = "", *db_database = NULL;

	phandle = h;

	homedir = (char *) strdup(getenv("HOME"));

	path = (char *) malloc(strlen(homedir) + strlen(DB_CONFIG_FILE) + 10);
	sprintf(path, "%s/.gaim/%s", homedir, DB_CONFIG_FILE);


	f = fopen(path, "r+");
	if (f == NULL) {
		return "Failed to open/create database config file!";
	}

	p = buf;
	while (fgets(buf, sizeof(buf), f)) {
		chomp(buf);

		if (strncmp(buf, "host: ", 6) == 0) {
			db_host = strdup(p + 6);
		}
		if (strncmp(buf, "user: ", 6) == 0) {
			db_user = strdup(p + 6);
		}
		if (strncmp(buf, "pass: ", 6) == 0) {
			db_pass = strdup(p + 6);
		}
		if (strncmp(buf, "database: ", 10) == 0) {
			db_database = strdup(p + 10);
		}
		if (strncmp(buf, "table: ", 7) == 0) {
			db_table = strdup(p + 7);
		}

	}
	fclose(f);

	if (!db_host || !db_user || !db_pass || !db_database || !db_table)
		return "Invalid/missing entries in config file!";

	mysqlConnection = mysql_init(mysqlConnection);

	if ((mysqlConnection = mysql_real_connect(mysqlConnection, db_host, db_user, db_pass, db_database, 3306, NULL, 0)) == NULL)
		return "Error connecting to mysql!";

	gaim_signal_connect(phandle, event_im_recv, get_im, NULL);
	gaim_signal_connect(phandle, event_im_send, send_im, NULL);

	return NULL;
}

char *name() {
	return "mysql converstation logger";
}

char *description() {
	return "Logs your converstations to a mysql database";
}

void chomp(char *s) {
        char *s1;
        s1 = s;
        while (*s1++) {
                if (strncmp(s1, "\r", 1) == 0 || strncmp(s1, "\n", 1) == 0) *s1 = '\0';
        }
        return;
}



int log_to_mysql(char *user, char *who, char *what) {
	pid_t pid;
	char *qry, *escaped_what;

	pid = fork();
	if (pid == -1) { /* error. */
		perror("fork");
		return 1;

	} else if (pid == 0) { /* child. */
		_exit(0);

	} else { /* parent. */
		waitpid(NULL);
		
		qry = (char *) malloc(strlen(user) + strlen(who) + (strlen(what) * 2) + 54);

		escaped_what = (char *) malloc(strlen(what) * 2 + 1);
		mysql_real_escape_string(mysqlConnection, escaped_what, what, strlen(what));

		sprintf(qry, "INSERT INTO `%s` VALUES(NULL, NULL, '%s', '%s', '%s')", db_table, user, who, escaped_what);

		if (mysql_query(mysqlConnection, qry) == 0) {
			/* good insert - log failed */
			log_failed();
		} else {
			/* log failed sends to file for later insertion*/
			log_to_file(qry);
		}

		return 0;
	}

}


int log_to_file(char *s) {
	FILE *f;
	char *homedir, *path;
	homedir = (char *) strdup(getenv("HOME"));
	path = (char *) malloc(strlen(homedir) + strlen(FAILED_LOG) + 10);
	sprintf(path, "%s/.gaim/%s", homedir, FAILED_LOG);

	if ((f = fopen(path, "a+")) == NULL) return 1;
	fputs(s, f);
	fputs("\n", f);
	fclose(f);
	return 0;
}

void log_failed(void) {
	FILE *f;
	char buf[4096];
	char *homedir, *path;

	if (mysql_ping(mysqlConnection) != 0) return;

	homedir = (char *) strdup(getenv("HOME"));
	path = (char *) malloc(strlen(homedir) + strlen(FAILED_LOG) + 10);
	sprintf(path, "%s/.gaim/%s", homedir, FAILED_LOG);

	if ((f = fopen(path, "r")) == NULL) return;

	while (fgets(buf, sizeof(buf), f)) {
		chomp(buf);
		mysql_query(mysqlConnection, buf);
	}
	fclose(f);
	unlink(path);
	return;
}
