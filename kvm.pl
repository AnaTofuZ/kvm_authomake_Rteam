#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long qw(:config auto_help);

# オプション指定

GetOptions(
    \my %opt,
    "group=s","num=i","from=i",
);

# whoami でユーザーが取れるのでrootか判断

if ( $> == 0){
    print "rootでお願いします!\n";
    die;
}

die "groupを指定してください "if (! $opt{group});

my $group =undef;

$group = "flogs" if $opt{group}=~ /^[fF].*/;
$group = "jelly" if $opt{group}=~ /^[jJ].*/;
$group = "dande" if $opt{group}=~ /^[dD].*/;

die "有効なgropuを指定して" if !defined $group;

my $number_vm = 0;
my $text = "./.group/$group";

if (! $opt{num}) {

    open(my $fh_vm_number,'<',$text);
    $number_vm +=$_ while (<$fh_vm_number>);
    $number_vm++;

} else {
    $number_vm = $opt{num};
}
    close $fh_vm_number;
    open $fh_vm_number;

if( $opt{from}){

    system("");
    open(my $fh_number,"<","./test");


} else{
    system("");

}


=pod

=encoding utf8

=head1 NAME

kvm.pl - VMインスタンスをよしなに作るやつ

=head1 SYNOPSIS

    ./kvm.pl --group jelly --num 5 --from 1

=head1 OPTIONS

=head2 --group=Gropus
グループ名を指定 (dandelion,flogs,jellyfish)

=head2 --num=NUM

作るVMの番号を指定

=head2 --from=NUM

複製基のvmを変更(MACアドレスは変更しない)

=head1 AUTHOR

Takahiro SHIMIZU E<lt>e155730@ie.u-ryukyu.ac.jpE<gt>

=cut
