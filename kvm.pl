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

    # numberが指定されていな場合はfileから現在立っているVM数を把握

    open(my $fh_vm_number,'<',$text);
    $number_vm +=$_ while (<$fh_vm_number>);
    $number_vm++;

} else {
    # number 指定時は引数に応じた命名規則を設定

    $number_vm = $opt{num};
}
    close $fh_vm_number;
    open $fh_vm_number;

if( $opt{from}){


    my $xml_pass = "/etc/libvirt/qemu/$group$opt{from}.xml";
    open(my $fh_old_xml,"<",$xml_pass);
    my $old_mac_add;
       
    while (my $line = <$fh_old_xml>) {
        chomp $line;    
        if($line =~/((?:[0-9a-f]{2}:?){6})/){
            $old_mac_add = $1;
            next;
        }
    }

    close $fh_old_xml;

    system("virt-clone --original $group$opt{from} --name $group$number_vm --file /home/kvm/2017");
    my $new_xml_pass = "/etc/libvirt/qemu/$group$number_vm.xml";
    open(my $new_xml_op,"<",$new_xml_pass);
    my  @putxml;

    while (my $line = <$new_xml_op>) {
        chomp $line;    
        if($line =~s/((?:[0-9a-f]{2}:?){6})/$old_mac_add/);

        push @putxml,$line;
    }

    close $new_xml_op;

    open (my $new_xml_out,">",$new_xml_pass);
    for  (@putxml){
        print $new_xml_out "$_\n";
    }

    close $new_xml_out;
    system("virsh define $new_xml_pass");


} else{
    my $xml_pass = "/etc/libvirt/qemu/$group$number_vm.xml";
    system("virt-clone --original $group$opt{from} --name $group$number_vm --file /home/kvm/2017");

}

open (my $out_vm_numbers, ">",$text);
print $out_vm_numbers $number_vm;
close $out_vm_numbers;

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
