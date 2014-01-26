# GAIM hax0r plugin
# http://www.signuts.net
# Sig Lange <exonic@signuts.net>
#
# Converts shit you say to hax0r talk.
 
GAIM::register("hax0r", "0.0.1", "goodbye", "");

sub goodbye {
	GAIM::print("hax0r", "hax0r has Terminated.");
}

 GAIM::add_event_handler("event_im_send", "hax0r");

sub hax0r {
	$index = $_[0];
	$sender = $_[1];
	$message = $_[2];

	%haxor = (
		"a" => "4",
		"e" => "3",
		"i" => "1",
		"o" => "0",
		"u" => "U",
		"w" => "\\\\'");

	$_ = $message;
        my($key, $value);
        while ( ($key, $value) = each(%haxor) ) {
		s/$key/$value/gi;
        }
	$message = $_;
	GAIM::print_to_conv($index, $sender, $message, 0);
	return 1;
}


