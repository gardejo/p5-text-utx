use inc::Module::Install 0.95;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;

# ================================================================
# gathering meta information
# ================================================================
    # individual gathering
    author          'MORIYA Masaki, alias Gardejo <moriya at cpan dot org>';
    resources (
        repository
            => 'git://github.com/gardejo/p5-text-utx.git',
        # (implicit assignment)
        # bugtracker
        #     => 'http://rt.cpan.org/Public/Dist/Display.html?Name='
        #      . 'Text-UTX',
        homepage
            => 'http://github.com/gardejo/p5-text-utx',
    );

    # the rest of information
    # abstract, author, license, name, perl_version(5.008_001), version
    all_from        'lib/Text/UTX.pm';

    no_index directory => 'examples';
#   no_index directory => 'extlib';

# ================================================================
# build dependency(-ies)
# ================================================================
#   build_requires  'Module::Install'                   => '0.80';
        # to avoid YAML::Tiny problem
#   build_requires  'Module::Load'                      => '0';
        # is in perl 5.009_004

# ================================================================
# general dependency(-ies)
# ================================================================
    requires        'Data::Util'                        => '0';
    requires        'DateTime'                          => '0';
    requires        'DateTime::Locale'                  => '0';
    requires        'DateTime::TimeZone'                => '0';
#   requires        'Encode'                            => '0';
        # was included by perl 5.007_003
#   requires        'List::MoreUtils'                   => '0';
        # was included by Moose
#   requires        'Locale::Country'                   => '0';
        # was included by perl 5.007_003
#   requires        'Locale::Language'                  => '0';
        # was included by perl 5.007_003
#   requires        'Memoize'                           => '0';
        # was included by perl 5.007_003
    requires        'Module::Pluggable::Object'         => '0';
    requires        'Moose'                             => '0.89_01';
        # for Moose::Meta::Attribute::Native
    requires        'MooseX::Clone'                     => '0';
    requires        'MooseX::StrictConstructor'         => '0';
    requires        'MooseX::Types'                     => '0';
    requires        'MooseX::Types::DateTimeX'          => '0';
    requires        'MooseX::Types::Locale::Country'    => '0.01';
    requires        'MooseX::Types::Locale::Language'   => '0.01';
    requires        'Regexp::Assemble'                  => '0';
#   requires        'Storable'                          => '0';
        # was included by perl 5.007_003
    requires        'Sub::Name'                         => '0';
    requires        'Tie::IxHash'                       => '0';
    requires        'Try::Tiny'                         => '0';
    requires        'namespace::clean'                  => '0.08';
        # cf. MooseX-Types-DateTime

# ================================================================
# optional dependency(-ies)
# ================================================================
    features (
        'Yada yada yada' => [
            -default => 0,
        #   recommends( 'English'                           => '0' ),
                # perl 5
        #   recommends( 'List::Util'                        => '0' ),
                # perl 5.007_003
        ],
        'Optmize File::Spec processes' => [
            -default => 0,
            recommends( 'File::Spec::Memoized'              => '0' ),
        ],
        'Loader/Saver implementation: Network' => [
            -default => 0,
            recommends( 'HTTP::Request::Common'             => '0' ),
            recommends( 'LWP::UserAgent'                    => '0' ),
        ],
    );

# ================================================================
# test dependency(-ies)
# ================================================================
    test_requires   'Test::Class'                       => '0.34';
    test_requires   'Test::Exception'                   => '0.27';
        # cf. MooseX-Types-DateTime
#   test_requires   'Test::Moose'                       => '0';
        # was included by Moose
    test_requires   'Test::More'                        => '0';
#   test_requires   'Test::mysqld'                      => '0';
    test_requires   'Test::Requires'                    => '0';
    test_requires   'Test::Warn'                        => '0';

# ================================================================
# author dependency(-ies)
# ================================================================
    author_requires 'Perl::Critic'                      => '0.094';
    author_requires 'Test::CPAN::Meta'                  => '0.12';
#   author_requires 'Test::Kwalitee'                    => '0';
        # always die (but xt/kwalitee.t need it)
    author_requires 'Test::NoTabs'                      => '0';
    author_requires 'Test::Perl::Critic'                => '0';
    author_requires 'Test::Pod'                         => '1.40';
    author_requires 'Test::Pod::Coverage'               => '1.08';
    author_requires 'Test::Synopsis'                    => '0.06';
    author_requires 'Test::UseAllModules'               => '0';

# ================================================================
# test(s)
# ================================================================
    tests                   't/*.t';
    recursive_author_tests  'xt';

# ================================================================
# including
# ================================================================
    auto_include_deps;
    # 'auto_include' grabs only immediate dependencies

# ================================================================
# installation
# ================================================================
#   auto_install;
    # 'auto_install' is deprecated

# ================================================================
# writter
# ================================================================
    WriteAll;
