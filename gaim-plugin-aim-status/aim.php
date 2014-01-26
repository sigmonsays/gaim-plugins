<?
	$file = "/htdocs/aimstatus";

/*		--- PERL-HOWTO ---
                0 the screenname of the buddy
                1 the alias of the buddy
                2 "Online" or "Offline"
                3 their warning level
                4 signon time, in seconds since the epoch
                5 idle time, in seconds (?)
                6 user class, an integer with bit values
                        AOL             1
                        ADMIN           2
                        UNCONFIRMED     4
                        NORMAL          8
                        AWAY            16
                7 their capabilites, an integer with bit values
                        BUDDYICON       1
                        VOICE           2
                        IMIMAGE         4
                        CHAT            8
                        GETFILE         16
                        SENDFILE        32
*/

function perl_chop($str) {
	return substr($str, 0, -1);
}
$buf = file($file);

echo "<table width=100% border=0 align=center>";
echo "<tr><th>$buf[1]</th></tr>";
echo "<tr><td class=none>";

if (perl_chop($buf[2]) == 'Online') {
	$online_time = date("F j, g:i:sa", $buf[4]);
	echo "I'm <font color=blue><b>Online</b></font> and have been signed on since $online_time<br>";

	if (perl_chop($buf[5]) > 0) { //i'm idle
		$online_idle = date("F j, g:i:sa", $buf[5]);
		echo "I must have walked away from my computer.<br>I have been idle since $online_idle<br>";
	} else {

		if (perl_chop($buf[6]) ==  9) { //i'm away.. I can't get my away message :)
			echo "I am away from my computer right now.<br>";
		}
	}

	if ($buf[3] > 0) {
		echo "Some <b>JACKASS</b> thought it'd be funny to warn me. My current warning level is at $buf[3] percent<br>";
	}
} else {
	$offline_time = date("F j, g:i:sa", filemtime($file));
	echo "I'm <font color=red><b>Offline</b></font> and have been signed off since $offline_time<br>";
}
echo "</td></tr>";
echo "</table>";
?>
