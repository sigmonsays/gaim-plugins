#!/usr/bin/perl

use DBI;
use HTTP::Date;

$dsn = "DBI:mysql:database=whatever;localhost:3306";
$dbuser = "root";
$dbpass = "FIXME";


my $mysqlConnection = DBI->connect($dsn, $dbuser, $dbpass);

$user = @ARGV[0];
$buddy = @ARGV[1];

print "$user - $buddy\n";

$_ = "X gisser X";

if ( m/^$user/i ) {
	print "Good\n";
}

while (<STDIN>) {
	$insert = 0;

	if ( m/^$user/ || m/^$buddy/ ) {
		$insert = 1;
	}

	if ( m/^ ---- New Conversation @ (.+) ----$/ ) {
		my $convo = $1;
		$insert = 0;
	}
	if ( m/^----/ || m/^ ----/ ) {
		$insert = 0;
	}
	

	if ( m/^(.+):(.+)$/ && $insert == 1) {
		$the_guy = $1;
		$text = $2;

		my $time = str2time($convo);

		local($sec, $min, $hour, $day, $month, $year) = localtime($time);
		$year += 1900;

		if (length($sec) == 1) { $sec = "0$sec"; }
		if (length($min) == 1) { $min = "0$min"; }
		if (length($hour) == 1) { $hour = "0$hour"; }
		if (length($day) == 1) { $day = "0$day"; }
		if (length($month) == 1) { $month = "0$month"; }
		$timestamp = $year . $month . $day . $hour . $min . $sec;

		$text =~ s/'/\\'/g, s/"/\\"/g;

		if ( m/^$user/i ) {
			$u = $user;
			$b = $the_guy;
		}

		if ( m/^$buddy/i ) {
			$u = $the_guy;
			$b = $user;
		}

		my $qry = "INSERT INTO `gaim-logs` VALUES(NULL, NULL, '$u', '$b', 'IMP - $text')";

		print "$qry\n";
	}
}

$mysqlConnection->disconnect;
