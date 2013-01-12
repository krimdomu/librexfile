#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Rexfile::Task;
   
use strict;
use warnings;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   if(! exists $self->{name}) {
      die("You have to define a task name.");
   }

   $self->{no_ssh} ||= 0;
   $self->{func}     = undef;
   $self->{executor} = undef;

   $self->{connection} = undef;

   return $self;
}

sub not_yet { die("Not yet!"); }

sub connection { shift->not_yet(); }
sub executor { shift->not_yet(); }
sub server { shift->not_yet(); }
sub set_server { shift->not_yet(); }
sub delete_server { shift->not_yet(); }
sub current_server { shift->not_yet(); }
sub is_remote { shift->not_yet(); }
sub is_local { shift->not_yet(); }
sub is_http { shift->not_yet(); }
sub is_https { shift->not_yet(); }
sub get_connection_type { shift->not_yet(); }
sub rethink_connection { shift->not_yet(); }
sub run_hook { shift->not_yet(); }
sub merge_auth { shift->not_yet(); }
sub get_sudo_password { shift->not_yet(); }
sub connect { shift->not_yet(); }
sub disconnect { shift->not_yet(); }

sub run {
   my ($self) = @_;
   my $rexfile_manager = Rex::Rexfile->new(file => $self->{__file__});
   $rexfile_manager->run_task($self->name);
}


sub hidden {
   my ($self) = @_;
   return $self->{hidden};
}

sub desc {
   my ($self) = @_;
   return $self->{desc};
}

sub set_desc {
   my ($self, $desc) = @_;
   $self->{desc} = $desc;
}

sub want_connect {
   my ($self) = @_;
   return $self->{no_ssh} == 0 ? 1 : 0;
}

sub modify {
   my ($self, $key, $value) = @_;

   if(ref($self->{$key}) eq "ARRAY") {
      push(@{ $self->{$key} }, $value);
   }
   else {
      $self->{$key} = $value;
   }
}

sub user {
   my ($self) = @_;
   if(exists $self->{auth} && $self->{auth}->{user}) {
      return $self->{auth}->{user};
   }
}

sub set_user {
   my ($self, $user) = @_;
   $self->{auth}->{user} = $user;
}

sub password {
   my ($self) = @_;
   if(exists $self->{auth} && $self->{auth}->{password}) {
      return $self->{auth}->{password};
   }
}

sub set_password {
   my ($self, $password) = @_;
   $self->{auth}->{password} = $password;
}

sub name {
   my ($self) = @_;
   return $self->{name};
}

sub code {
   my ($self) = @_;
   return $self->{func};
}

sub set_code {
   my ($self, $code) = @_;
   $self->{func} = $code;
}

sub set_auth {
   my ($self, $key, $value) = @_;

   if(scalar(@_) > 3) {
      my $_d = shift;
      $self->{auth} = { @_ };
   }
   else {
      $self->{auth}->{$key} = $value;
   }
}

sub parallelism {
   my ($self) = @_;
   return $self->{parallelism};
}


sub set_parallelism {
   my ($self, $para) = @_;
   $self->{parallelism} = $para;
}

   
sub get_data {
   my ($self) = @_;

   return {
      func => $self->{func},
      server => $self->{server},
      desc => $self->{desc},
      no_ssh => $self->{no_ssh},
      hidden => $self->{hidden},
      auth => $self->{auth},
      before => $self->{before},
      after  => $self->{after},
      around => $self->{around},
      name => $self->{name},
      executor => $self->{executor},
      connection_type => $self->{connection_type},
   };
}

   
=back

=cut



1;
