# random idle
# http://www.signuts.net
# Sig Lange <exonic@signuts.net>
#
# Every minute it changes your idle time to a random number.
GAIM::register("random idle", "0.0.1", "goodbye", "");
GAIM::add_timeout_handler(1, "notify");
sub notify {
        srand();

        # 86400 seconds in a day
        GAIM::command("idle", (int(rand() * 60) * 86400);
        GAIM::add_timeout_handler(10, "notify");
}
sub goodbye {
        GAIM::print("random idle", "Terminated");
}

