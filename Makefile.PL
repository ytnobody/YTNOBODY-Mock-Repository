use inc::Module::Install;
name 'YTNOBODY-Mock-Repository';
all_from 'lib/YTNOBODY/Mock/Repository.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
install_git_submodule;
WriteAll;
