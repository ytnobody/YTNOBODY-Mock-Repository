#line 1
package Module::Install::GitSubmodule;

use strict;
use warnings;
use base qw( Module::Install::Base );
use vars qw( $VERSION );
use Carp;
use Config;
use File::Spec;
use Git::Class::Worktree;
use Guard;

$VERSION = 0.01;

sub install_git_submodule {
    my $self = shift;
    my $basedir = $self->admin->{base};
    my $extlib = File::Spec->catfile( $basedir, "extlib" );

    my $wt = Git::Class::Worktree->new( path => $basedir );

    $wt->git(qw/submodule update --init/);
    for my $submod_info ( $wt->git(qw/submodule/) ) {
         my $guard = guard { chdir $basedir };
         my ( $hash, $path ) = $submod_info =~ /^[\-\s]?([0-9a-fA-F]+)\s(.+)\s/;
 
         my $worktree_path = File::Spec->catfile($basedir, $path);
         chdir $worktree_path;
 
         my $subr = Git::Class::Worktree->new( path => $worktree_path );
         $subr->pull;
 
         my $cpanm = search_cpanm();
         my $res = system( "$cpanm ./ -l $extlib" );
         if ( $res ) {
             Carp::croak("Failure to install submodule $path");
         }
         else {
             print "*** submodule $path was installed ***\n";
         }
    }
    my $res = system("cp -rfv $extlib/lib/perl5/* $basedir/lib/");

    return 1 unless $res;
}

sub search_cpanm {
    my @search_path = qw( installbin );
    my $cpanm = `/usr/bin/which cpanm`;
    $cpanm =~ s/\n//;
    return $cpanm if $cpanm;
    for my $key ( @search_path ) {
        $cpanm = File::Spec->catfile( $Config{$key}, 'cpanm' );
        return $cpanm if $cpanm;
    }
}


1;

__END__

