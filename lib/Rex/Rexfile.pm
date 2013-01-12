package Rex::Rexfile;

use Data::Dumper;
use Storable qw(nfreeze thaw);
use File::Basename;
use Cwd qw(getcwd);

use Rex::Rexfile::Task;

$Storable::Deparse = 1;
$Storable::Eval = 1;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

sub get_tasks {
   my ($self) = @_;

   $self->get_data(sub {
      my @ret;

      my @tasks = Rex::TaskList->create()->get_tasks;

      for my $task_name (@tasks) {
         my $task = bless(Rex::TaskList->create()->get_task($task_name), "Rex::Rexfile::Task");
         $task->{__file__} = $self->{file};
         push(@ret, $task);
      }

      return { type => "array", array => \@ret };
   });
}

sub run_task {
   my ($self, $task, $server) = @_;

   $self->get_data(sub {

      if(! $server) {
         return { type => "string", string => Rex::TaskList->create()->get_task($task)->run() };
      }
      else {
         return { type => "string", string => Rex::TaskList->create()->get_task($task)->run($server) };
      }

   });
}

sub load {
   my ($self) = @_;

   my $rexfile = $self->{file};

   my $rexfile_text = eval { local(@ARGV, $/) = ($rexfile); <>; };
   eval "package Rex::CLI; use Rex -base; do('$rexfile');";

}

sub get_data {
   my ($self, $code) = @_;

   pipe my $reader, my $writer;

   my $pid = fork();
   if($pid == 0) {
      # child
      close $reader;
      binmode $writer;

      my $rexfile = $self->{file};
      my $old_dir = getcwd;
      my $dir;
      eval {
         $dir = dirname($rexfile);
      };
      if($dir) {
         chdir $dir;
      }

      $self->load;
      my $ret = $code->($self);

      chdir $old_dir;

      print $writer nfreeze($ret);
      close $writer;

      exit;
   }
   else {
      # parent
      close $writer;
      binmode $reader;
      my $data = "";
      while(my $line = <$reader>) {
         $data .= $line;
      }
      my $ref = thaw $data;
      waitpid $pid, 0;
      close $reader;

      return $ref->{$ref->{type}};
   }
}

1;
