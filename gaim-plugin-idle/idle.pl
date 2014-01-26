# 2002-01-01
# Gaim Idle
# http://www.signuts.net/
# Sig Lange <exonic@signuts.net>
#
# Updated to work with Gaim 0.6x by Mark Doliner

$handle = GAIM::register("Gaim Idle", "0.0.1", "goodbye", "");

GAIM::add_event_handler($handle, "event_im_send", "idle");

sub description {
	my($a, $b, $c, $d, $e, $f) = @_; 
	("Gaim Idle", "0.0.1",
	"Type /idle [seconds] in a conversation\n\tto set your idle time.",
	"Sig Lange &lt;exonic\@signuts.net>",
	"http://gaim.sourceforge.net/",
	"/dev/null");
}

sub goodbye {
	GAIM::print("Gaim Idle", "Gaim Idle has terminated.");
}

sub idle {
	$index = $_[0];
	$sender= $_[1];
	$msg   = $_[2];

	# strip HTML
	$_ = $msg;
	s/<(?:[^>\'\"]*|([\'\"]).*?\1)*>//gs;
	$cmdline = $_;

	# parse commands and arguments
	$_ = $cmdline;
	/(\/[a-z]*[ ])([a-z0-9 ]*)/;
	$args = $2;
	if ($1 eq "") { $cmd=$_; } else { $cmd=$1; }
	$_ = $cmd; s/[ ]//g; $cmd = $_;

	if ($cmd eq "/idle") {
		if ($args eq "") {
			GAIM::write_to_conv($sender, 2, "Syntax Error, Usage: /idle [seconds]", "system");
		} else {
			GAIM::command("idle", $args);
			GAIM::write_to_conv($sender, 2, "Idle changed to $args", "system");
		}
		$_[2] = "";
	}
}
