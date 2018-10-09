use strict;
use warnings;

use Email::MIME;
use Email::Outlook::Message;

use open qw(:std :utf8);

process();

sub process {
  # Make sure we have a path
  if ($#ARGV != 0) {
    print "Usage: DumpEmail.py [path]";
    exit 1;
  }

  # Prepare the output files
  mkdir "out";

  # Loop through all of the MSG files in the path
  my @files = glob($ARGV[0] . '/*.msg');
  for my $file (@files) {
    print "Processing \'$file\'...\n";
    my $msg = new Email::Outlook::Message $file;
    my $mime = $msg->to_email_mime;
    processSubParts($mime);
    print "\n";
  }
}

sub processSubParts {
  my $mime = shift;

  for my $part ($mime->subparts) {
    if ($part->content_type =~ m/text\/plain/) {
	  writeFile($part, 'txt');
	} elsif ($part->content_type =~ m/application\/rtf/) {
	  writeFile($part, 'rtf');
    } elsif ($part->content_type =~ m/openxmlformats-officedocument/) {
	  writeRawFile($part, 'docx');
	} elsif ($part->content_type =~ m/image\/jpeg/) {
	  writeRawFile($part, 'jpeg');
    } elsif ($part->content_type =~ m/image\/png/) {
	  writeRawFile($part, 'png');
	} elsif ($part->content_type =~ m/application\/pdf/) {
	  writePdf($part);
    } elsif ($part->content_type =~ m/multipart\/alternative/) {
	  processSubParts($part);
	} else {
	  print $part->content_type . "\n";
	  print $part->debug_structure;
	}
  }
}

sub writeFile {
  my $part = shift;
  my $extension = shift;
  
  my @count = glob("out/*.$extension");
  my $filename = $#count + 1;
  open (my $fh, '>', "out/$filename.$extension");
  print $fh $part->body;
  close $fh;
  
  print uc($extension) . " found, written as $filename.$extension\n";
}

sub writePdf {
  my $part = shift;
 
  my $filename = "out/" . $part->filename;
  open (my $fh, '>:raw', $filename);
  print $fh $part->body;
  close $fh;
  
  print "PDF found, written as $filename\n"; 
}

sub writeRawFile {
  my $part = shift;
  my $extension = shift;
  
  my @count = glob("out/*.$extension");
  my $filename = $#count + 1;
  open (my $fh, '>:raw', "out/$filename.$extension");
  print $fh $part->body;
  close $fh;
  
  print uc($extension) . " found, written as $filename.$extension\n";
}
