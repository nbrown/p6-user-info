use v6;

use NativeCall;

class group_t is repr('CStruct') {
    has Str $.gr_name;
    has uint32 $.gr_gid;
    has CArray[Str] $.gr_mem;
}

sub getgrgid(uint32 $gid) returns group_t is native('libc') { ... };
sub getgrnam(Str $group)  returns group_t is native('libc') { ... };

class Group::Info {

    has $.group-name;
    has $.group-id;

    multi method new(Str :$group-name is copy = '', Int :$group-id is copy = -1) {
        if $group-name eq '' && $group-id != -1 {
            given $*OS {
                when m:i/win/ {
                }
                default {
                    my $gr = getgrgid($group-id);
                    $group-name = $gr.gr_name;
                }
            }
        }
        elsif $group-name ne '' && $group-id == -1 {
            given $*OS {
                when m:i/win/ {
                }
                default {
                    my $gr = getgrnam($group-name);
                    $gr.perl.say;
                    $group-id   = $gr.gr_gid;
                }
            }
        }
        return self.bless(:$group-id, :$group-name);
    }

    submethod BUILD(:$!group-id, :$!group-name) {
    }
}

# vim:ft=perl6
