#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long qw(:config posix_default no_ignore_case bundling auto_help);

# オプション指定

GetOptions(
    \my %opt,
    "group=s","num=i",
);

# whoami でユーザーが取れるのでrootか判断

if ( `whoami` eq "root"){
    print "rootでお願いします!\n";
    exit 1;
}



=pod

=encoding utf8

=head1 NAME

kvm.pl - VMインスタンスをよしなに作るやつ

=head1 SYNOPSIS

    ./kvm.pl --group jelly --num 5

=head1 OPTIONS

=head2 --group=Gropus
グループ名を指定 (dandelion,flogs,jellyfish)

=head2 --num=NUM

作るVMの番号を指定

=head1 AUTHOR

Takahiro SHIMIZU E<lt>e155730@ie.u-ryukyu.ac.jpE<gt>

=cut
