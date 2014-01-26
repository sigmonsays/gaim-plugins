#define GAIM_PLUGINS
#include "gaim.h"

#include <gtk/gtk.h>
#include <string.h>

void *handle;

static void r_im(struct gaim_connection *gc, char **who, char **what, void *m) {
	char buf[256];
	struct conversation *cnv = find_conversation(*who);
	GtkWindow *win;
	gint new_x, new_y, x, y, i, d = 0;

	char *me = g_strdup(normalize(gc->username));

	if (!strcmp(me, normalize(*who))) {
		g_free(me);
		return;
	}
	g_free(me);

	if (cnv == NULL)
		cnv = new_conversation(*who);

	win = (GtkWindow *)cnv->window;

	gtk_window_position(GTK_WINDOW (win),GTK_WIN_POS_NONE);

	gdk_window_get_origin (GTK_WIDGET(win)->window, &x, &y);

	for(i=0; i<5; i++) {
		if ((d = !d)) {
			new_x = x + 5;
			new_y = y + 5;
		} else {
			new_x = x - 5;
			new_y = y - 5;
		}
		gtk_widget_set_uposition(GTK_WINDOW (win), new_x, new_y);
		gtk_widget_draw(GTK_WIDGET(win), NULL);
		usleep(10000);
	}

	/* put it back to where it came from */
	gtk_widget_set_uposition(GTK_WINDOW (win), x, y);
	gtk_widget_draw(GTK_WIDGET(win), NULL);

}

char *gaim_plugin_init(GModule *hndl) {
	handle = hndl;

	gaim_signal_connect(handle, event_im_recv, r_im, NULL);

	return NULL;
}

char *name() {
	return "Shake-IM";
}

char *description() {
	return "Shakes the IM window when you receive a message.";
}
