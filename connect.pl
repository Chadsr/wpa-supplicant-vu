#!/usr/bin/env perl
use strict;
use warnings;
use File::Path qw(make_path);

sub  input { print shift; my $res = <>; $res =~ s/^\s+|\s+$//g; return $res}

my $iface = $1 if (split "\n", `iwconfig 2> /dev/null`)[0] =~ /([\w\d]+).*/;
my $conf_dir  = glob('~/.wifi_config');
make_path($conf_dir);

my $conf_file = "$conf_dir/VU-Campusnet.conf";
goto FILE_EXISTS if ( -e $conf_file);

# query these later
my $vunetid  = input "Gimme your vunet id:";
my $password = input "Gimme your password:";

my $wpa_sup  = `which wpa_supplicant`;
$wpa_sup =~ s/^\s+|\s+$//g;

my $conf = <<"END_CONF";
country=NL
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
update_config=1

ap_scan=1
fast_reauth=1

network={
        ssid="VU-Campusnet"
        mode=0
        scan_ssid=1
        key_mgmt=WPA-EAP
        eap=TTLS
        # anonymous_identity="anonymous\@vu.nl"

        identity="$vunetid\@vu.nl"
        password="$password"

        phase2="auth=PAP"
}
END_CONF

open(my $fh, '>', $conf_file) or die "Could not open file '$conf_file' $!";
print $fh $conf;
close $fh;

FILE_EXISTS:
system("wpa_supplicant -B -i $iface -c $conf_file") || die "fuck, it didnt work m8";
