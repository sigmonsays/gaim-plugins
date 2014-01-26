# 2002-01-01
# Gaim Reverse
# http://www.signuts.net/
# Sig Lange <exonic@signuts.net>
# A good new years day plugin, dont' wanna attempt anything
# too hard after last night.

GAIM::register("Gaim Reverse", "0.0.1", "goodbye", "");

GAIM::add_event_handler("event_im_send", "reverse");

sub goodbye {
        GAIM::print("Gaim Reverse", "Gaim Reverse terminated.");
}


sub reverse {
        $index = $_[0];
        $sender = $_[1];
        $message = $_[2];

        # strip HTML
        $_ = $message;
        s/<(?:[^>\'\"]*|([\'\"]).*?\1)*>//gs;
        $message = $_;

        $message = reverse $message;

        GAIM::print_to_conv($index, $sender, $message, 0);
        return 1;
}

