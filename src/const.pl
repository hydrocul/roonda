
my $ENV_SELF_PATH = 'ROONDA_SELF_PATH';
my $ENV_TMP_PATH = 'ROONDA_TMP_PATH';

my $ENV_EXPERIMENTAL = 'ROONDA_EXPERIMENTAL';

my $TOKEN_TYPE_SYMBOL  = 1;
my $TOKEN_TYPE_STRING  = 2;
my $TOKEN_TYPE_HEREDOC = 11;
my $TOKEN_TYPE_INTEGER = 3;
#my $TOKEN_TYPE_FLOAT  = 4;
my $TOKEN_TYPE_OPEN    = 5;
my $TOKEN_TYPE_CLOSE   = 6;
my $TOKEN_TYPE_EOF     = 7;
my $TOKEN_TYPE_LIST    = 8;

my $LANG_SEXPR   = 'sexpr';
my $LANG_SH      = 'sh';
my $LANG_PERL    = 'perl';
my $LANG_RUBY    = 'ruby';
my $LANG_PYTHON2 = 'python2';
my $LANG_PYTHON3 = 'python3';
my $LANG_PHP     = 'php';

my $FORMAT_SEXPR = 'sexpr';
my $FORMAT_JSON  = 'json';

my $OP_ORDER_MIN                = 0;
my $OP_ORDER_PYTHON_RANGE       = 1; # Python :
my $OP_ORDER_CONTROL_OR         = 2; # Perl, Python
my $OP_ORDER_CONTROL_AND        = 3; # Perl, Python
my $OP_ORDER_CONTROL_NOT        = 4; # Perl, Ruby, Python
my $OP_ORDER_PERL_PRINT_RIGHT   = 5; # Perl print etc.
my $OP_ORDER_ARG_COMMA          = 10; # PHP, Perl, Ruby, Python
my $OP_ORDER_PYTHON_EQUAL       = 11; # Python
my $OP_ORDER_PYTHON_COMPARISON  = 11; # Python
my $OP_ORDER_PHP_CONTROL_OR     = 12; # PHP
my $OP_ORDER_PHP_CONTROL_XOR    = 13; # PHP
my $OP_ORDER_PHP_CONTROL_AND    = 14; # PHP
my $OP_ORDER_ASSIGN             = 20; # PHP, Perl, Ruby, Python
my $OP_ORDER_TERNARY            = 20; # PHP, Perl
my $OP_ORDER_RUBY_TERNARY       = 21; # Ruby
my $OP_ORDER_RANGE              = 22; # Perl, Ruby
my $OP_ORDER_LOGICAL_OR         = 30; # PHP, Perl, Ruby
my $OP_ORDER_LOGICAL_AND        = 40; # PHP, Perl, Ruby
my $OP_ORDER_BIT_OR             = 50; # PHP, Perl, Python
my $OP_ORDER_BIT_XOR            = 60; # PHP, Python
my $OP_ORDER_BIT_AND            = 70; # PHP, Perl, Python
my $OP_ORDER_EQUAL              = 80; # PHP, Perl, Ruby
my $OP_ORDER_COMPARISON         = 90; # PHP, Perl, Ruby
my $OP_ORDER_RUBY_BIT_OR        = 91; # Ruby
my $OP_ORDER_RUBY_BIT_AND       = 92; # Ruby
my $OP_ORDER_BIT_SHIFT          = 100; # PHP, Perl, Ruby, Python
my $OP_ORDER_ADDITION           = 110; # PHP, Perl, Ruby, Python
my $OP_ORDER_MULTIPLICATION     = 120; # PHP, Perl, Ruby, Python
my $OP_ORDER_PERL_REGEXP        = 121; # Perl =~ !~
my $OP_ORDER_UNARY              = 130; # PHP !, Perl ! ~ \ + -, Ruby -
my $OP_ORDER_POWER              = 140; # Perl, Ruby, Python
my $OP_ORDER_PHP_INSTANCE_OF    = 141; # PHP incanceof
my $OP_ORDER_PERL_INCREMENT     = 142; # PHP ++ -- ~ (cast), Perl ++ --
my $OP_ORDER_RUBY_UNARY         = 143; # Ruby + ! ~
my $OP_ORDER_PERL_ARROW         = 143; # Perl ->
my $OP_ORDER_PERL_PRINT_LEFT    = 144; # Perl print etc.
my $OP_ORDER_LIST_INDEX         = 150; # PHP [], Ruby [], Python [] ()
my $OP_ORDER_NAMESPACE          = 151; # Ruby ::
my $OP_ORDER_PHP_NEW            = 152; # PHP new
my $OP_ORDER_DOT                = 160; # 未調査

my $KEYWD_SH_EXEC      = 'exec';
my $KEYWD_SH_EXPORT    = 'export';
my $KEYWD_SH_PIPE      = 'pipe';
my $KEYWD_SH_ROONDA    = 'roonda';
my $KEYWD_SH_SUBSH     = 'subsh';
my $KEYWD_SH_GROUP     = 'group';
my $KEYWD_SH_BACKTICKS = 'backticks';

my $KEYWD_IMPORT       = 'import';
my $KEYWD_FUNCTION     = 'function';
my $KEYWD_IF           = 'if';
my $KEYWD_FOREACH      = 'foreach';
my $KEYWD_APPLY        = 'apply';
my $KEYWD_PRINT        = 'print';
my $KEYWD_PRINTLN      = 'println';
my $KEYWD_DUMP         = 'dump';
my $KEYWD_ASSIGN       = 'assign';
my $KEYWD_REF          = 'ref';
my $KEYWD_DOT          = 'dot';
my $KEYWD_STRCAT       = 'strcat';
my $KEYWD_TRUE         = 'true';
my $KEYWD_FALSE        = 'false';
my $KEYWD_LIST         = 'list';

