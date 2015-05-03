use v6;

use NativeCall;
class passwd_t is repr('CStruct') {
    has Str $.pw_name;
    has Str $.pw_pass;
    has uint32 $.pw_uid;
    has uint32 $.pw_gid;
    has Str $.pw_gecos;
    has Str $.pw_dir;
    has Str $.pw_shell;
}

sub getpwuid(uint32 $uid) returns passwd_t is native('libc') { ... };
sub getpwnam(Str $user)   returns passwd_t is native('libc') { ... };

sub getuid()  returns uint32 is native('libc') { ... };
#sub geteuid() returns uint32 is native('libc') { ... };
#sub getgid()  returns uint32 is native('libc') { ... };
#sub getegid() returns uint32 is native('libc') { ... };

#sub getgrgid(uint32 $gid) returns group_t is native('libc') { ... };
#sub getgrnam(Str $group)  returns group_t is native('libc') { ... };

class User::Info {
    use Group::Info;

    has $.user-name;
    has $.user-id;
    has Group::Info $.group-info;

    multi method new() {
        my uint32 $uid = getuid();
        return User::Info.new($uid);
    }

    multi method new(Str $user-name) {
        my ($user-id, $group-info);
        given $*OS {
            when m:i/win/ {
            }
            default {
                my $pw = getpwnam($user-name);
                $user-id    = $pw.pw_uid;
                $group-info = Group::Info.new(:group-id($pw.pw_gid));
            }
        }
        return self.bless(:$user-name, :$user-id, :$group-info);
    }

    multi method new(uint32 $user-id) {
        my ($user-name, $group-info);
        given $*OS {
            when m:i/win/ {
            }
            default {
                my $pw = getpwuid($user-id);
                $user-name  = $pw.pw_name;
                $group-info = Group::Info.new(:group-id($pw.pw_gid));
            }
        }
        return self.bless(:$user-name, :$user-id, :$group-info);
    }


    submethod BUILD(:$!user-name, :$!user-id, :$!group-info) {
    }
}

# vim:ft=perl6
