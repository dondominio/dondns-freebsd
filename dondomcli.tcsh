#!/bin/tcsh
# ==========================================
#  DONDOMINIO FreeBSD Dynamic IP Client
# ==========================================
#   @path:    /usr/local/bin/dondomcli.tcsh
#   @version: 0.9.1
#   @author:  Borja Ruiz Castro
#   @mail:    borja@libcrack.so
#   @date:    jue jul  3 00:51:07 CEST 2014

setenv SHELL /bin/tcsh
setenv PATH /etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

set DEFAULTCONFIG = "/usr/local/etc/dondomcli.conf"
set APIURL = "https://dondns.dondominio.com/xml/"
set CURL = `which curl`
set CURLOPT = " -A CurlFreeBSDDonDNS/1.1 --silent --insecure --data "
set SED = `which sed`

set DDCONFIG = "$DEFAULTCONFIG"
set DDUSER = ""
set DDPASSWORD = ""
set DDIP = ""
set DDHOST = ""

if ( "$#" == 0 ) then
    goto Usage
endif

if ( ! -x "$CURL" ) then
    echo "Cannot locate curl binary"
    exit 1
endif

while ( $#argv > 0 )
    switch ( $argv[1] )
        case -c: 
            shift
            set DDCONFIG = "$argv[1]"
            # bash to tcsh config
            $SED -i -e 's/="/ = "/g' $DDCONFIG
            $SED -i -e 's/^DD/set DD/g' $DDCONFIG
            source $DDCONFIG
            breaksw
        case -u: 
            shift
            set DDUSER = "$argv[1]"
            breaksw
        case -p: 
            shift
            set DDPASSWORD = "$argv[1]"
            breaksw
        case -i: 
            shift
            set DDIP = "$argv[1]"
            breaksw
        case -h: 
            shift
            set DDHOST = "$argv[1]"
            breaksw
        default:
            shift
            echo "Unknown parameter: $argv[1]"
        endif
    endsw
    shift
end

test -z "$DDUSER" && echo "Missing username" && goto Usage
test -z "$DDPASSWORD" && echo "Missing password" && goto Usage
test -z "$DDHOST" && echo "Missing target host" && goto Usage

set HOSTS = (`echo "$DDHOST" | $SED -e 's/,/ /g'`)

foreach MYHOST ( $HOSTS )
    $CURL $CURLOPT "user=$DDUSER&password=$DDPASSWORD&host=$MYHOST&ip=$DDIP" "$APIURL"
end

exit 0

Usage:
    echo ""
    echo "======================================"
    echo " DonDominio Dynamic IP Client FreeBSD"
    echo "======================================"
    test -z "$1" || echo " ERROR: $1" 
    echo
    echo "Usage: $0 -u <USER> -p <PASSWORD> -h <HOST> [-i <IP>]"
    echo "Usage: $0 -c <FILECONFIG> [-i <IP>] [-h <HOST>] [-p <PASSWORD>] [-u <USER>]"
    echo ""
    echo "Note:"
    echo " * Default endifle conendifg is $DEFAULTCONFIG";
    echo " * If not speciendifed the IP address, this is obtained automatically"
    echo ""
    exit 1

