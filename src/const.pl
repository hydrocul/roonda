
my $ENV_SELF_PATH = 'ROONDA_SELF_PATH';
my $ENV_TMP_PATH = 'ROONDA_TMP_PATH';

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

my $OP_ORDER_MIN       = 0;
my $OP_ORDER_ARG_COMMA = 5;
my $OP_ORDER_PLUS      = 10;
my $OP_ORDER_MULTIPLY  = 20;

my $KEYWD_SH_EXEC      = 'exec';
my $KEYWD_SH_ASSIGN    = 'assign';
my $KEYWD_SH_PIPE      = 'pipe';
my $KEYWD_SH_ROONDA    = 'roonda';
my $KEYWD_SH_BACKTICKS = 'backticks';
my $KEYWD_SH_REF       = 'ref';

my $KEYWD_STDIN_DATA   = 'stdin_data';

my $KEYWD_IF           = 'if';
my $KEYWD_APPLY        = 'apply';
my $KEYWD_PRINT        = 'print';
my $KEYWD_STRCAT       = 'strcat';

