# 2002-01-01
# Gaim Scramble
# http://www.signuts.net/
# Sig Lange <exonic@signuts.net>

GAIM::register("Gaim Scramble", "0.0.1", "goodbye", "");

GAIM::add_event_handler("event_im_send", "scramble");

sub goodbye {
        GAIM::print("Gaim Scramble", "Gaim Scramble terminated.");
}


sub scramble {
        $index = $_[0];
        $sender = $_[1];
        $message = $_[2];

        # strip HTML
        $_ = $message;
        s/<(?:[^>\'\"]*|([\'\"]).*?\1)*>//gs;
        $message = $_;

        @words = split(/\s/, $message);
        # randomize word list
        $count = @words;
        srand();
        for($i=0; $i<$count*2; $i++) {
                $x = rand($count);
                $y = rand($count);

                # swap the two variables
                $t = $words[$x];
                $words[$x] = $words[$y];
                $words[$y] = $t;
        }

        $message = join " ", @words;

        GAIM::print_to_conv($index, $sender, $message, 0);
        return 1;
}

