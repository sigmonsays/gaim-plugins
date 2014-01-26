# 2002-01-12
# aim-status.pl
# Sig Lange <exonic@signuts.net>
#
# A perl script that writes your status to a file (for use in a web page)

# Tested and works with Gaim 0.49 & 0.50

GAIM::register("aim-status", "0.0.1", "cleanup", "");

# CONFIGURE YOUR JUNK HERE
# the user to do the stats for
$self = "USERNAME";
$title = "aim-status";
$output = "/htdocs/aimstatus";
$refresh = 5;

# END OF CONFIGURATION

GAIM::add_event_handler("event_buddy_idle", "idle"); 
GAIM::add_event_handler("event_buddy_away", "away");
GAIM::add_timeout_handler($refresh, "update");

sub update {
	@cids = GAIM::get_info(1);
	@buf = ($cids[0], $self);
	update_info(@buf);
	GAIM::add_timeout_handler($refresh, "update");
}

sub idle {
	$user = $_[1];
	if ($user eq $self) {
		update_info($_);
	}
}

sub away {
        $user = $_[1];

        if ($user eq $self) {
                update_info(@_);
        }
}

sub update_info {

	$index = $_[0];
	$user = $_[1];
	$self = GAIM::get_info(3, $index);

	if (open(F, ">$output")) {
		@buf = GAIM::user_info($index, $self);
		foreach $x (@buf) {
			print F "$x\n";
		}
		close(F);
	} else {
		GAIM::print($title, "Couldn't open $output!");
	}
}

sub cleanup {
	GAIM::print($title, "$title terminated");
}
