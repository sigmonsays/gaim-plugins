# GAIM alias-reply plugin for dondo
# http://www.signuts.net
# Sig Lange <exonic@signuts.net>
#
# Replies with users alias when they say your name
# Not sure of the importance of this.. but hey.. :)

$myname = "sig";

GAIM::register("aliasreply", "0.0.1", "quit", "");
GAIM::add_event_handler("event_im_recv", "aliasreply");

sub quit {
	print "aliasreply: Unloading.....\n";
}

sub aliasreply {
	$index = $_[0];
	$sender = $_[1];
	$message = $_[2];

	$_ = $message;
	s/<(?:[^>\'\"]*|([\'\"]).*?\1)*>//gs;

	if ( m/$myname/i ) {

		@ginfo = GAIM::user_info($index, $sender);
		$message = $ginfo[1];
		GAIM::print_to_conv($index, $sender, $message, 0);
	}

}
