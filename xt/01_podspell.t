use Test::More;
eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;
add_stopwords(map { split /[\s\:\-]/ } <DATA>);
$ENV{LANG} = 'C';
all_pod_files_spelling_ok('lib');
__DATA__
satoshi azuma
ytnobody at gmail dot com
YTNOBODY::Mock::Repository
#     DBH
#     DSL
#     Iroha
#     ORM
#     dbh
#     Kaiji
#     attr
#     DPath
#     JSON
#     STDIN
#     json
#     sneecr
