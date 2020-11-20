#!/usr/bin/perl

#+++
#
# nimstat.pl
#
# This script will parse the nim=xxxxx part of a log line
#
# Configuration file format:
#    /N/provider: name-of-cloudlet
#    /N/schema: schema-definition
#    Example:
#       /0/schema: //[provider]/[cloudlet-off-reason]/[do-cloudlet]/[logic-executed]/[matching-akaruleid]/[policy-match-error]/#[policy-selector-cost]
#    /N/<schema-item>/<value>: meaning
# where:
#   N is the Provider ID
#   schema-item is the items from the schema
#   value       for each possible value of the schema-item
#      special value: description - for full description of field
#      description can be multiple line value.
#
# 24-Sep-2018 Ted Corning
# Initial version
#
# 27-Sep-2018 Ted
# Updated how the Nimbus configuration is used. 
#
# 14-Mar-2019 Ted
# Added -only flag in case you have a status with multiple but just want one. Yes, lazy.
#
#---

use strict;
use Getopt::Long;
#use Switch;
use File::Basename;
use File::Find;

#+++
#
# Command-line arguments 
#
#---
my %optctl;
usage() unless GetOptions ( \%optctl, "info|describe", "verbose:1", "test", "only=s" );
usage() unless $ARGV[0] || $optctl{test};


#+++
#
# Log the usage
#
#---
`/home/tcorning/scripts/usage_logger.sh \$PPID > /dev/null 2>&1` unless $optctl{notrack};


#+++
#
# global variables
#
#---
my $config_file = "nimbus.conf";
my %nimbus_conf;
my $do_info = $optctl{info};
my $do_test = $optctl{test};
my $do_only = $optctl{only};
my $verbose = $optctl{verbose};

my $nimstatus = $ARGV[0];   #nim=//0//1/1/1c3f7bfda1e86466/-/#109091;


#+++
#
# Parse the config file and load the hash
#
#---
parse_conf();
# If it's just testing, parse all example entries in config
if ( $do_test )
   {
   run_tests();
   exit;
   }
# Check to see if the argument is a full r line
if ( $nimstatus =~ /vcd=|nimb=/ )
   {
   die "No nim status in line\n" unless $nimstatus =~ /nim=/;
   $nimstatus =~ s/.*nim=/nim=/;
   $nimstatus =~ s/;.*//;
   }

#+++
#
# Split the value and get the provider
#
#---
printf "%-30s: %s\n", "Parsing Multiple Values", $nimstatus if $nimstatus =~ /\\/;
$nimstatus =~ s/^nim=//;

# Now split on backslash in case of multiple cloudlets, and loop
my @statuses = split /\\/, $nimstatus;

for my $nimvalue ( @statuses )
   {
   next if ( $do_only && $nimvalue !~ /^\/\/$do_only\// );
   printf "%-30s: %s\n", "Parsing value", $nimvalue;

   # And parse it
   parse_nimbus( $nimvalue );
   print "\n";
   }

exit;


#+++
#
# parse_nimbus
#
# This routine parses the actual NIM value and prints the summary
#
#---
sub parse_nimbus
{
   my $nimvalue = shift;
   my $provider;

   #+++
   #
   # Extract the status values. Remove the initial // first.
   #
   #---
   $nimvalue = substr( $nimvalue, 2 );
   my @values = split /\//, $nimvalue;
   $provider = $values[0];

   # Now get the Schema
   my $schema = $nimbus_conf{"$provider/schema"};
   print "Schema: $schema\n" if $verbose;

   #+++
   # Print nim status key/value, if -verbose
   if ( $verbose > 1 )
      {
      for my $v ( @values )
         {
         print "v = $v\n";
         }
      }
   #
   #---


   #+++
   # Get the provider information
   #
   my $provinfo = $nimbus_conf{"$provider/provider"};

   # And print it
   printf "%-30s: %s - %s\n", "Provider", $provider, $provinfo;
   #
   #---


   #+++
   # Parse the values according to the schema. Start at 1 since we already
   # did the Provider.
   #
   my @pieces = split /\//, $schema;
   print "pieces has ", $#pieces, "\n" if $verbose;
   # Fix for ALB not having a / between last 2 values
   if ( $provider == 9 && $values[$#values] !~ /^\#/ )
      {
      my $lasttwo = pop @values;
      my ( $err, $cost ) = split /\#/, $lasttwo;
      push @values, $err;
      push @values, "#" . $cost;
      }

   # Loop through the schema pieces. The array is 2 off from the values array
   for( my $i = 1; $i < $#pieces - 1; $i++ )
      {
      # Get the piece and strip the [ and ]
      my $p = $pieces[$i+2];
      $p = substr( $p, 1, -1 );

      # Provder was already printed, so ignore it
      next if ( $p eq "provider" );
      # Debug data
      print "$i, \"$values[$i]\"\n" if $verbose;

      # There may still be a "[" for the last item, since it has a #
      $p = substr( $p, 1 ) if substr( $p, 0, 1 ) eq "[";

      # Replace empty value with the word "empty"
      if ( $values[$i] eq "" )
         {
         $values[$i] = "empty";
         }

      # More debug data
      print "   $i, \"$values[$i]\"\n" if $verbose;
      print "   $p: Lookin to match $values[$i]\n" if $verbose;

      # Get the meaning from the config, and convert %7C to |
      my $out_info = $nimbus_conf{"$provider/$p/$values[$i]"};
      $values[$i] =~ s/%7C/|/g;
      printf "%-30s: %s", $p, $values[$i];
      print " ( $out_info )" if $out_info;

      # If -info/-describe specified, give the full descriptions too
      if ( $do_info && $nimbus_conf{"$provider/$p/description"} )
         {
         my $desc = $nimbus_conf{"$provider/$p/description"};
         # Indent the output
         $desc =~ s/\n/\n   /gs;
         print "\n   ", $desc;
         }
      print "\n";
      }
}
         

#+++
#
# parse_conf
#
# Parse the configuration file. 
#
#---
sub parse_conf
{
   open CONFFILE, "<", $config_file or die "Could not open $config_file\n";

   # Change the RS to ^/ to get full values in a single read
   $/ = "\n/";
   while( my $line = <CONFFILE> )
      {
      # Split to a key/value pair
      my ( $key, $value ) = split /:\s+/, $line, 2;
      # Skip comments
      next if $key =~ /^#/;

      # remove the slash from the next key
      chop( $value ) if ( $value =~ /\/$/ );
      # and the newline
      chop( $value );

      # And finally remove any trailing comments we slurped up at the end
      $value =~ s/\n#.*//s;

      # And set the config hash
      $nimbus_conf{$key} = $value;
      print STDERR "Key = $key, value = \n=====$value=====\n" if $verbose;
      }
   $/ = "\n";
}

#+++
#
# run_tests
#
# Parse any /N/example* entries as a test
#
#---
sub run_tests
{
   # Loop through the config keys
   for my $k ( sort keys %nimbus_conf )
      {
      # We only want example entries
      next unless $k =~ /\/example/;

      # Print the key, split at nim=, and parse the value
      print "$k:\n";
      my ( undef, $nimvalue ) = split /=/, $nimbus_conf{$k};
      printf "%-30s: %s\n", "Parsing value", $nimvalue;
      parse_nimbus( $nimvalue );
      print "   ==========\n";
      }
}
      
      
sub usage
{
   print STDERR qq(Usage: nimstatus 'nim=xxxxxxx' [ -info ] [ -test ]
Where
   -info - print full description of each field
   -test - parse any example entries in the nimbus config file
);
   exit;
}
