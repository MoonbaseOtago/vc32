/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1





# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif


/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    t_la = 258,                    /* t_la  */
    t_lr = 259,                    /* t_lr  */
    t_value = 260,                 /* t_value  */
    t_sp = 261,                    /* t_sp  */
    t_epc = 262,                   /* t_epc  */
    t_csr = 263,                   /* t_csr  */
    t_s0 = 264,                    /* t_s0  */
    t_s1 = 265,                    /* t_s1  */
    t_a0 = 266,                    /* t_a0  */
    t_a1 = 267,                    /* t_a1  */
    t_a2 = 268,                    /* t_a2  */
    t_a3 = 269,                    /* t_a3  */
    t_a4 = 270,                    /* t_a4  */
    t_a5 = 271,                    /* t_a5  */
    t_and = 272,                   /* t_and  */
    t_or = 273,                    /* t_or  */
    t_xor = 274,                   /* t_xor  */
    t_sub = 275,                   /* t_sub  */
    t_add = 276,                   /* t_add  */
    t_mv = 277,                    /* t_mv  */
    t_nop = 278,                   /* t_nop  */
    t_inv = 279,                   /* t_inv  */
    t_ebreak = 280,                /* t_ebreak  */
    t_jalr = 281,                  /* t_jalr  */
    t_jr = 282,                    /* t_jr  */
    t_lw = 283,                    /* t_lw  */
    t_lb = 284,                    /* t_lb  */
    t_sw = 285,                    /* t_sw  */
    t_sb = 286,                    /* t_sb  */
    t_lea = 287,                   /* t_lea  */
    t_lui = 288,                   /* t_lui  */
    t_li = 289,                    /* t_li  */
    t_beqz = 290,                  /* t_beqz  */
    t_bnez = 291,                  /* t_bnez  */
    t_bltz = 292,                  /* t_bltz  */
    t_bgez = 293,                  /* t_bgez  */
    t_j = 294,                     /* t_j  */
    t_jal = 295,                   /* t_jal  */
    t_sll = 296,                   /* t_sll  */
    t_srl = 297,                   /* t_srl  */
    t_sra = 298,                   /* t_sra  */
    t_word = 299,                  /* t_word  */
    t_byte = 300,                  /* t_byte  */
    t_name = 301,                  /* t_name  */
    t_nl = 302                     /* t_nl  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);



/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_t_la = 3,                       /* t_la  */
  YYSYMBOL_t_lr = 4,                       /* t_lr  */
  YYSYMBOL_t_value = 5,                    /* t_value  */
  YYSYMBOL_t_sp = 6,                       /* t_sp  */
  YYSYMBOL_t_epc = 7,                      /* t_epc  */
  YYSYMBOL_t_csr = 8,                      /* t_csr  */
  YYSYMBOL_t_s0 = 9,                       /* t_s0  */
  YYSYMBOL_t_s1 = 10,                      /* t_s1  */
  YYSYMBOL_t_a0 = 11,                      /* t_a0  */
  YYSYMBOL_t_a1 = 12,                      /* t_a1  */
  YYSYMBOL_t_a2 = 13,                      /* t_a2  */
  YYSYMBOL_t_a3 = 14,                      /* t_a3  */
  YYSYMBOL_t_a4 = 15,                      /* t_a4  */
  YYSYMBOL_t_a5 = 16,                      /* t_a5  */
  YYSYMBOL_t_and = 17,                     /* t_and  */
  YYSYMBOL_t_or = 18,                      /* t_or  */
  YYSYMBOL_t_xor = 19,                     /* t_xor  */
  YYSYMBOL_t_sub = 20,                     /* t_sub  */
  YYSYMBOL_t_add = 21,                     /* t_add  */
  YYSYMBOL_t_mv = 22,                      /* t_mv  */
  YYSYMBOL_t_nop = 23,                     /* t_nop  */
  YYSYMBOL_t_inv = 24,                     /* t_inv  */
  YYSYMBOL_t_ebreak = 25,                  /* t_ebreak  */
  YYSYMBOL_t_jalr = 26,                    /* t_jalr  */
  YYSYMBOL_t_jr = 27,                      /* t_jr  */
  YYSYMBOL_t_lw = 28,                      /* t_lw  */
  YYSYMBOL_t_lb = 29,                      /* t_lb  */
  YYSYMBOL_t_sw = 30,                      /* t_sw  */
  YYSYMBOL_t_sb = 31,                      /* t_sb  */
  YYSYMBOL_t_lea = 32,                     /* t_lea  */
  YYSYMBOL_t_lui = 33,                     /* t_lui  */
  YYSYMBOL_t_li = 34,                      /* t_li  */
  YYSYMBOL_t_beqz = 35,                    /* t_beqz  */
  YYSYMBOL_t_bnez = 36,                    /* t_bnez  */
  YYSYMBOL_t_bltz = 37,                    /* t_bltz  */
  YYSYMBOL_t_bgez = 38,                    /* t_bgez  */
  YYSYMBOL_t_j = 39,                       /* t_j  */
  YYSYMBOL_t_jal = 40,                     /* t_jal  */
  YYSYMBOL_t_sll = 41,                     /* t_sll  */
  YYSYMBOL_t_srl = 42,                     /* t_srl  */
  YYSYMBOL_t_sra = 43,                     /* t_sra  */
  YYSYMBOL_t_word = 44,                    /* t_word  */
  YYSYMBOL_t_byte = 45,                    /* t_byte  */
  YYSYMBOL_t_name = 46,                    /* t_name  */
  YYSYMBOL_t_nl = 47,                      /* t_nl  */
  YYSYMBOL_48_ = 48,                       /* '+'  */
  YYSYMBOL_49_ = 49,                       /* '-'  */
  YYSYMBOL_50_ = 50,                       /* '*'  */
  YYSYMBOL_51_ = 51,                       /* '/'  */
  YYSYMBOL_52_ = 52,                       /* '('  */
  YYSYMBOL_53_ = 53,                       /* ')'  */
  YYSYMBOL_54_ = 54,                       /* ','  */
  YYSYMBOL_55_ = 55,                       /* '.'  */
  YYSYMBOL_56_ = 56,                       /* ':'  */
  YYSYMBOL_57_ = 57,                       /* '='  */
  YYSYMBOL_YYACCEPT = 58,                  /* $accept  */
  YYSYMBOL_exp = 59,                       /* exp  */
  YYSYMBOL_e1 = 60,                        /* e1  */
  YYSYMBOL_e2 = 61,                        /* e2  */
  YYSYMBOL_xr = 62,                        /* xr  */
  YYSYMBOL_rx = 63,                        /* rx  */
  YYSYMBOL_r = 64,                         /* r  */
  YYSYMBOL_rm = 65,                        /* rm  */
  YYSYMBOL_ins = 66,                       /* ins  */
  YYSYMBOL_label = 67,                     /* label  */
  YYSYMBOL_line = 68,                      /* line  */
  YYSYMBOL_program = 69                    /* program  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  85
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   438

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  58
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  12
/* YYNRULES -- Number of rules.  */
#define YYNRULES  84
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  205

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   302


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      52,    53,    50,    48,    54,    49,    55,    51,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    56,     2,
       2,    57,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int8 yyrline[] =
{
       0,     5,     5,     6,     7,    10,    11,    12,    14,    15,
      16,    17,    20,    21,    24,    25,    26,    28,    29,    31,
      32,    33,    34,    35,    36,    37,    38,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    93,    96,    97,    98,
      99,   100,   101,   104,   105
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 1
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "t_la", "t_lr",
  "t_value", "t_sp", "t_epc", "t_csr", "t_s0", "t_s1", "t_a0", "t_a1",
  "t_a2", "t_a3", "t_a4", "t_a5", "t_and", "t_or", "t_xor", "t_sub",
  "t_add", "t_mv", "t_nop", "t_inv", "t_ebreak", "t_jalr", "t_jr", "t_lw",
  "t_lb", "t_sw", "t_sb", "t_lea", "t_lui", "t_li", "t_beqz", "t_bnez",
  "t_bltz", "t_bgez", "t_j", "t_jal", "t_sll", "t_srl", "t_sra", "t_word",
  "t_byte", "t_name", "t_nl", "'+'", "'-'", "'*'", "'/'", "'('", "')'",
  "','", "'.'", "':'", "'='", "$accept", "exp", "e1", "e2", "xr", "rx",
  "r", "rm", "ins", "label", "line", "program", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-140)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     191,   422,   422,   422,   422,   422,   364,   377,  -140,  -140,
    -140,   377,   377,   377,   377,   377,   377,   422,   422,   422,
     422,   422,   422,   422,   -37,   -31,   422,   422,   422,   -32,
    -140,   -34,    -2,   232,  -140,   150,  -140,  -140,  -140,  -140,
    -140,  -140,  -140,  -140,    -6,    -3,     0,     3,     4,  -140,
       6,  -140,  -140,     8,    16,  -140,  -140,  -140,    30,  -140,
    -140,  -140,    31,    32,    37,    38,    52,    53,    54,    60,
      66,    68,    69,  -140,  -140,  -140,  -140,  -140,  -140,   100,
       1,  -140,  -140,    80,     5,  -140,  -140,    79,   348,   422,
     422,   422,    67,   377,    67,   377,   151,   193,   234,   272,
     293,   317,   317,    81,    82,    84,    86,  -140,    78,   317,
     317,   317,  -140,   -41,   -39,    93,    87,  -140,  -140,  -140,
    -140,  -140,  -140,  -140,  -140,  -140,  -140,  -140,  -140,  -140,
      88,    91,   279,    92,   291,    95,   303,    99,    90,   102,
    -140,  -140,  -140,  -140,  -140,  -140,   317,  -140,  -140,   105,
     317,   317,   317,   317,   317,  -140,   106,   108,    28,   109,
     111,   392,   112,   142,   403,   148,   149,   414,   153,   139,
    -140,  -140,  -140,  -140,  -140,  -140,   157,  -140,  -140,   154,
     183,  -140,  -140,   187,   190,  -140,  -140,   194,   195,  -140,
    -140,   223,   225,  -140,   227,  -140,  -140,  -140,  -140,  -140,
    -140,  -140,  -140,  -140,  -140
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,    38,    39,
      40,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      82,     0,     0,     0,    83,     0,    19,    20,    21,    22,
      23,    24,    25,    26,     0,     0,     0,     0,     0,    14,
       0,    15,    16,     0,     0,    18,    17,    13,     0,    12,
      41,    42,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    67,    68,    69,    70,    71,    76,     0,
       0,    79,    77,     0,     0,     1,    84,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    11,    74,     0,
       0,     0,    73,     4,     7,     0,     0,    78,    72,    31,
      27,    28,    29,    30,    32,    33,    36,    34,    35,    37,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      61,    62,    63,    64,    65,    66,     0,     8,     9,     0,
       0,     0,     0,     0,     0,    80,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      75,    10,     2,     3,     5,     6,     0,    44,    48,     0,
       0,    46,    50,     0,     0,    52,    56,     0,     0,    54,
      58,     0,     0,    60,     0,    81,    43,    47,    45,    49,
      51,    55,    53,    57,    59
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -140,   -33,  -139,   -74,  -140,   238,    17,    -1,   122,  -140,
     246,  -140
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_uint8 yydefgoto[] =
{
       0,   149,   113,   114,    56,    57,    58,    59,    32,    33,
      34,    35
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      44,    45,    46,    47,    48,    54,   107,   150,   151,    73,
      79,   152,   153,   174,   175,    74,    66,    67,    68,    69,
      70,    71,    72,    80,    78,    75,    76,    77,    60,    61,
      62,    63,    64,    65,   179,   147,   148,    36,    37,    38,
      39,    40,    41,    42,    43,    81,   112,   116,    87,   109,
     110,    88,   117,   111,    89,   119,   115,    90,    91,   124,
      92,   127,    93,   131,   133,   135,   137,   139,   140,   141,
      94,    49,   107,    55,    51,    52,    36,    37,    38,    39,
      40,    41,    42,    43,    95,    96,    97,   120,   121,   122,
     123,    98,    99,   107,   156,   107,   168,    36,    37,    38,
      39,    40,    41,    42,    43,   107,   100,   101,   102,   125,
     126,   128,   129,   170,   103,   109,   110,   172,   173,   111,
     104,   176,   105,   106,    79,   118,   146,   142,   143,   157,
     144,   160,   145,   163,   155,   166,   109,   110,   109,   110,
     111,   154,   111,   158,   161,   194,   108,   164,   109,   110,
      85,   167,   111,     1,   169,    84,   107,   180,   171,   177,
     184,   178,   181,   188,   182,   185,   192,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,     1,   186,    29,    30,   107,   109,
     110,   189,   190,   130,   195,    31,   193,   196,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,     1,   197,    29,    30,   107,
     198,   109,   110,   199,    53,   132,    31,   200,   201,     2,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,   202,   107,   203,    82,
     204,    86,   109,   110,   107,   159,   134,    83,    36,    37,
      38,    39,    40,    41,    42,    43,   107,   162,   107,     0,
      36,    37,    38,    39,    40,    41,    42,    43,   107,   165,
       0,     0,    36,    37,    38,    39,    40,    41,    42,    43,
     109,   110,   107,     0,   136,     0,     0,   109,   110,     0,
       0,   111,     0,     0,     0,     0,     0,     0,     0,   109,
     110,   109,   110,   111,     0,   138,     0,     0,     0,     0,
       0,   109,   110,   107,     0,   111,     0,    36,    37,    38,
      39,    40,    41,    42,    43,   109,   110,     0,    49,   111,
      50,    51,    52,    36,    37,    38,    39,    40,    41,    42,
      43,    49,     0,    55,    51,    52,    36,    37,    38,    39,
      40,    41,    42,    43,     0,     0,   109,   110,   183,     0,
     111,    36,    37,    38,    39,    40,    41,    42,    43,   187,
       0,     0,    36,    37,    38,    39,    40,    41,    42,    43,
     191,     0,     0,    36,    37,    38,    39,    40,    41,    42,
      43,    36,    37,    38,    39,    40,    41,    42,    43
};

static const yytype_int16 yycheck[] =
{
       1,     2,     3,     4,     5,     6,     5,    48,    49,    46,
      44,    50,    51,   152,   153,    46,    17,    18,    19,    20,
      21,    22,    23,    57,    56,    26,    27,    28,    11,    12,
      13,    14,    15,    16,     6,   109,   110,     9,    10,    11,
      12,    13,    14,    15,    16,    47,    79,    80,    54,    48,
      49,    54,    47,    52,    54,    88,    55,    54,    54,    92,
      54,    94,    54,    96,    97,    98,    99,   100,   101,   102,
      54,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    54,    54,    54,    88,    89,    90,
      91,    54,    54,     5,     6,     5,     6,     9,    10,    11,
      12,    13,    14,    15,    16,     5,    54,    54,    54,    92,
      93,    94,    95,   146,    54,    48,    49,   150,   151,    52,
      54,   154,    54,    54,    44,    46,    48,    46,    46,   130,
      46,   132,    46,   134,    47,   136,    48,    49,    48,    49,
      52,    48,    52,    52,    52,     6,    46,    52,    48,    49,
       0,    52,    52,     3,    52,    33,     5,   158,    53,    53,
     161,    53,    53,   164,    53,    53,   167,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,     3,    53,    46,    47,     5,    48,
      49,    53,    53,    52,    47,    55,    53,    53,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,     3,    53,    46,    47,     5,
      53,    48,    49,    53,     6,    52,    55,    53,    53,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    53,     5,    53,    47,
      53,    35,    48,    49,     5,     6,    52,    55,     9,    10,
      11,    12,    13,    14,    15,    16,     5,     6,     5,    -1,
       9,    10,    11,    12,    13,    14,    15,    16,     5,     6,
      -1,    -1,     9,    10,    11,    12,    13,    14,    15,    16,
      48,    49,     5,    -1,    52,    -1,    -1,    48,    49,    -1,
      -1,    52,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    48,
      49,    48,    49,    52,    -1,    52,    -1,    -1,    -1,    -1,
      -1,    48,    49,     5,    -1,    52,    -1,     9,    10,    11,
      12,    13,    14,    15,    16,    48,    49,    -1,     4,    52,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,     4,    -1,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    -1,    -1,    48,    49,     6,    -1,
      52,     9,    10,    11,    12,    13,    14,    15,    16,     6,
      -1,    -1,     9,    10,    11,    12,    13,    14,    15,    16,
       6,    -1,    -1,     9,    10,    11,    12,    13,    14,    15,
      16,     9,    10,    11,    12,    13,    14,    15,    16
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    46,
      47,    55,    66,    67,    68,    69,     9,    10,    11,    12,
      13,    14,    15,    16,    65,    65,    65,    65,    65,     4,
       6,     7,     8,    63,    65,     6,    62,    63,    64,    65,
      64,    64,    64,    64,    64,    64,    65,    65,    65,    65,
      65,    65,    65,    46,    46,    65,    65,    65,    56,    44,
      57,    47,    47,    55,    66,     0,    68,    54,    54,    54,
      54,    54,    54,    54,    54,    54,    54,    54,    54,    54,
      54,    54,    54,    54,    54,    54,    54,     5,    46,    48,
      49,    52,    59,    60,    61,    55,    59,    47,    46,    59,
      65,    65,    65,    65,    59,    64,    64,    59,    64,    64,
      52,    59,    52,    59,    52,    59,    52,    59,    52,    59,
      59,    59,    46,    46,    46,    46,    48,    61,    61,    59,
      48,    49,    50,    51,    48,    47,     6,    65,    52,     6,
      65,    52,     6,    65,    52,     6,    65,    52,     6,    52,
      59,    53,    59,    59,    60,    60,    59,    53,    53,     6,
      65,    53,    53,     6,    65,    53,    53,     6,    65,    53,
      53,     6,    65,    53,     6,    47,    53,    53,    53,    53,
      53,    53,    53,    53,    53
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    58,    59,    59,    59,    60,    60,    60,    61,    61,
      61,    61,    62,    62,    63,    63,    63,    64,    64,    65,
      65,    65,    65,    65,    65,    65,    65,    66,    66,    66,
      66,    66,    66,    66,    66,    66,    66,    66,    66,    66,
      66,    66,    66,    66,    66,    66,    66,    66,    66,    66,
      66,    66,    66,    66,    66,    66,    66,    66,    66,    66,
      66,    66,    66,    66,    66,    66,    66,    66,    66,    66,
      66,    66,    66,    66,    66,    66,    67,    68,    68,    68,
      68,    68,    68,    69,    69
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     3,     3,     1,     3,     3,     1,     2,     2,
       3,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     1,     1,
       1,     2,     2,     7,     6,     7,     6,     7,     6,     7,
       6,     7,     6,     7,     6,     7,     6,     7,     6,     7,
       6,     4,     4,     4,     4,     4,     4,     2,     2,     2,
       2,     2,     4,     3,     3,     5,     2,     2,     3,     2,
       4,     6,     1,     1,     2
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* exp: e1 '+' exp  */
#line 5 "vc.y"
                                        { yyval = yyvsp[-2] + yyvsp[0]; }
#line 1376 "vc.tab.c"
    break;

  case 3: /* exp: e1 '-' exp  */
#line 6 "vc.y"
                                        { yyval = yyvsp[-2] - yyvsp[0]; }
#line 1382 "vc.tab.c"
    break;

  case 4: /* exp: e1  */
#line 7 "vc.y"
                                        { yyval = yyvsp[0]; }
#line 1388 "vc.tab.c"
    break;

  case 5: /* e1: e2 '*' e1  */
#line 10 "vc.y"
                                        { yyval = yyvsp[-2] * yyvsp[0]; }
#line 1394 "vc.tab.c"
    break;

  case 6: /* e1: e2 '/' e1  */
#line 11 "vc.y"
                                        { yyval = (yyvsp[0]==0?0:yyvsp[-2] / yyvsp[0]); }
#line 1400 "vc.tab.c"
    break;

  case 7: /* e1: e2  */
#line 12 "vc.y"
                                        { yyval = yyvsp[0]; }
#line 1406 "vc.tab.c"
    break;

  case 8: /* e2: '+' e2  */
#line 14 "vc.y"
                                        { yyval = yyvsp[0]; }
#line 1412 "vc.tab.c"
    break;

  case 9: /* e2: '-' e2  */
#line 15 "vc.y"
                                        { yyval = -yyvsp[0]; }
#line 1418 "vc.tab.c"
    break;

  case 10: /* e2: '(' exp ')'  */
#line 16 "vc.y"
                                        { yyval = yyvsp[-1]; }
#line 1424 "vc.tab.c"
    break;

  case 11: /* e2: t_value  */
#line 17 "vc.y"
                                        { yyval = yyvsp[0]; }
#line 1430 "vc.tab.c"
    break;

  case 12: /* xr: rm  */
#line 20 "vc.y"
                                        { yyval = 8|yyvsp[0]; }
#line 1436 "vc.tab.c"
    break;

  case 13: /* xr: rx  */
#line 21 "vc.y"
                                        { yyval = yyvsp[0]; }
#line 1442 "vc.tab.c"
    break;

  case 14: /* rx: t_lr  */
#line 24 "vc.y"
                                        { yyval = 1; }
#line 1448 "vc.tab.c"
    break;

  case 15: /* rx: t_epc  */
#line 25 "vc.y"
                                        { yyval = 3; }
#line 1454 "vc.tab.c"
    break;

  case 16: /* rx: t_csr  */
#line 26 "vc.y"
                                        { yyval = 4; }
#line 1460 "vc.tab.c"
    break;

  case 17: /* r: xr  */
#line 28 "vc.y"
                                        { yyval = yyvsp[0]; }
#line 1466 "vc.tab.c"
    break;

  case 18: /* r: t_sp  */
#line 29 "vc.y"
                                        { yyval = 2; }
#line 1472 "vc.tab.c"
    break;

  case 19: /* rm: t_s0  */
#line 31 "vc.y"
                                        { yyval = 0; }
#line 1478 "vc.tab.c"
    break;

  case 20: /* rm: t_s1  */
#line 32 "vc.y"
                                        { yyval = 1; }
#line 1484 "vc.tab.c"
    break;

  case 21: /* rm: t_a0  */
#line 33 "vc.y"
                                        { yyval = 2; }
#line 1490 "vc.tab.c"
    break;

  case 22: /* rm: t_a1  */
#line 34 "vc.y"
                                        { yyval = 3; }
#line 1496 "vc.tab.c"
    break;

  case 23: /* rm: t_a2  */
#line 35 "vc.y"
                                        { yyval = 4; }
#line 1502 "vc.tab.c"
    break;

  case 24: /* rm: t_a3  */
#line 36 "vc.y"
                                        { yyval = 5; }
#line 1508 "vc.tab.c"
    break;

  case 25: /* rm: t_a4  */
#line 37 "vc.y"
                                        { yyval = 6; }
#line 1514 "vc.tab.c"
    break;

  case 26: /* rm: t_a5  */
#line 38 "vc.y"
                                        { yyval = 7; }
#line 1520 "vc.tab.c"
    break;

  case 27: /* ins: t_and rm ',' rm  */
#line 41 "vc.y"
                                        { yyval = 0x8c61|(yyvsp[-2]<<7)|(yyvsp[0]<<2); }
#line 1526 "vc.tab.c"
    break;

  case 28: /* ins: t_or rm ',' rm  */
#line 42 "vc.y"
                                        { yyval = 0x8c41|(yyvsp[-2]<<7)|(yyvsp[0]<<2); }
#line 1532 "vc.tab.c"
    break;

  case 29: /* ins: t_xor rm ',' rm  */
#line 43 "vc.y"
                                        { yyval = 0x8c21|(yyvsp[-2]<<7)|(yyvsp[0]<<2); }
#line 1538 "vc.tab.c"
    break;

  case 30: /* ins: t_sub rm ',' rm  */
#line 44 "vc.y"
                                        { yyval = 0x8c01|(yyvsp[-2]<<7)|(yyvsp[0]<<2); }
#line 1544 "vc.tab.c"
    break;

  case 31: /* ins: t_and rm ',' exp  */
#line 45 "vc.y"
                                        { yyval = 0x8801|(yyvsp[-2]<<7)|imm6(yyvsp[0]); }
#line 1550 "vc.tab.c"
    break;

  case 32: /* ins: t_add t_sp ',' exp  */
#line 46 "vc.y"
                                        { yyval = 0x6101 | addsp(yyvsp[0]); }
#line 1556 "vc.tab.c"
    break;

  case 33: /* ins: t_add t_sp ',' r  */
#line 47 "vc.y"
                                        { yyval = 0x8002|(2<<7)|(yyvsp[0]<<2); }
#line 1562 "vc.tab.c"
    break;

  case 34: /* ins: t_add rm ',' exp  */
#line 48 "vc.y"
                                        { yyval = 0x0001|(yyvsp[-2]<<7)|imm8(yyvsp[0], 0); }
#line 1568 "vc.tab.c"
    break;

  case 35: /* ins: t_add rm ',' r  */
#line 49 "vc.y"
                                        { yyval = 0x9002|((8|yyvsp[-2])<<7)|(yyvsp[0]<<2); }
#line 1574 "vc.tab.c"
    break;

  case 36: /* ins: t_add rx ',' r  */
#line 50 "vc.y"
                                        { yyval = 0x9002|(yyvsp[-2]<<7)|(yyvsp[0]<<2); }
#line 1580 "vc.tab.c"
    break;

  case 37: /* ins: t_mv r ',' r  */
#line 51 "vc.y"
                                        { yyval = 0x8002|(yyvsp[-2]<<7)|(yyvsp[0]<<2); }
#line 1586 "vc.tab.c"
    break;

  case 38: /* ins: t_nop  */
#line 52 "vc.y"
                                        { yyval = 0x0001; }
#line 1592 "vc.tab.c"
    break;

  case 39: /* ins: t_inv  */
#line 53 "vc.y"
                                        { yyval = 0x0000; }
#line 1598 "vc.tab.c"
    break;

  case 40: /* ins: t_ebreak  */
#line 54 "vc.y"
                                        { yyval = 0x9002; }
#line 1604 "vc.tab.c"
    break;

  case 41: /* ins: t_jalr r  */
#line 55 "vc.y"
                                        { yyval = 0x9002|(yyvsp[0]<<7); }
#line 1610 "vc.tab.c"
    break;

  case 42: /* ins: t_jr r  */
#line 56 "vc.y"
                                        { yyval = 0x8002|(yyvsp[0]<<7); }
#line 1616 "vc.tab.c"
    break;

  case 43: /* ins: t_lw r ',' exp '(' t_sp ')'  */
#line 57 "vc.y"
                                           { yyval = 0x4002|(yyvsp[-5]<<7)|offX(yyvsp[-3]); }
#line 1622 "vc.tab.c"
    break;

  case 44: /* ins: t_lw r ',' '(' t_sp ')'  */
#line 58 "vc.y"
                                        { yyval = 0x4002|(yyvsp[-4]<<7)|offX(0); }
#line 1628 "vc.tab.c"
    break;

  case 45: /* ins: t_lb r ',' exp '(' t_sp ')'  */
#line 59 "vc.y"
                                           { yyval = 0x6002|(yyvsp[-5]<<7)|off(yyvsp[-3]); chkr(yyvsp[-5]); }
#line 1634 "vc.tab.c"
    break;

  case 46: /* ins: t_lb r ',' '(' t_sp ')'  */
#line 60 "vc.y"
                                        { yyval = 0x6002|(yyvsp[-4]<<7)|off(0); chkr(yyvsp[-4]); }
#line 1640 "vc.tab.c"
    break;

  case 47: /* ins: t_lw r ',' exp '(' rm ')'  */
#line 61 "vc.y"
                                         { yyval = 0x4000|(yyvsp[-1]<<7)|roffX(yyvsp[-3])|((yyvsp[-5]&7)<<2); chkr(yyvsp[-5]); }
#line 1646 "vc.tab.c"
    break;

  case 48: /* ins: t_lw r ',' '(' rm ')'  */
#line 62 "vc.y"
                                        { yyval = 0x4000|(yyvsp[-1]<<7)|roffX(0)|((yyvsp[-4]&7)<<2); chkr(yyvsp[-4]); }
#line 1652 "vc.tab.c"
    break;

  case 49: /* ins: t_lb r ',' exp '(' rm ')'  */
#line 63 "vc.y"
                                         { yyval = 0x6000|(yyvsp[-1]<<7)|roff(yyvsp[-3])|((yyvsp[-5]&7)<<2); chkr(yyvsp[-5]); }
#line 1658 "vc.tab.c"
    break;

  case 50: /* ins: t_lb r ',' '(' rm ')'  */
#line 64 "vc.y"
                                        { yyval = 0x6000|(yyvsp[-1]<<7)|roff(0)|((yyvsp[-4]&7)<<2); chkr(yyvsp[-4]); }
#line 1664 "vc.tab.c"
    break;

  case 51: /* ins: t_sw r ',' exp '(' t_sp ')'  */
#line 65 "vc.y"
                                           { yyval = 0xc002|(yyvsp[-5]<<7)|offX(yyvsp[-3]); }
#line 1670 "vc.tab.c"
    break;

  case 52: /* ins: t_sw r ',' '(' t_sp ')'  */
#line 66 "vc.y"
                                        { yyval = 0xc002|(yyvsp[-4]<<7)|offX(0); }
#line 1676 "vc.tab.c"
    break;

  case 53: /* ins: t_sb r ',' exp '(' t_sp ')'  */
#line 67 "vc.y"
                                           { yyval = 0xe002|(yyvsp[-5]<<7)|off(yyvsp[-3]); chkr(yyvsp[-5]); }
#line 1682 "vc.tab.c"
    break;

  case 54: /* ins: t_sb r ',' '(' t_sp ')'  */
#line 68 "vc.y"
                                        { yyval = 0xe002|(yyvsp[-4]<<7)|off(0); chkr(yyvsp[-4]); }
#line 1688 "vc.tab.c"
    break;

  case 55: /* ins: t_sw r ',' exp '(' rm ')'  */
#line 69 "vc.y"
                                         { yyval = 0xc000|(yyvsp[-1]<<7)|roffX(yyvsp[-3])|((yyvsp[-5]&7)<<2); chkr(yyvsp[-5]); }
#line 1694 "vc.tab.c"
    break;

  case 56: /* ins: t_sw r ',' '(' rm ')'  */
#line 70 "vc.y"
                                        { yyval = 0xc000|(yyvsp[-1]<<7)|roffX(0)|((yyvsp[-4]&7)<<2); chkr(yyvsp[-4]); }
#line 1700 "vc.tab.c"
    break;

  case 57: /* ins: t_sb r ',' exp '(' rm ')'  */
#line 71 "vc.y"
                                         { yyval = 0xe000|(yyvsp[-1]<<7)|roff(yyvsp[-3])|((yyvsp[-5]&7)<<2); chkr(yyvsp[-5]); }
#line 1706 "vc.tab.c"
    break;

  case 58: /* ins: t_sb r ',' '(' rm ')'  */
#line 72 "vc.y"
                                        { yyval = 0xe000|(yyvsp[-1]<<7)|roff(0)|((yyvsp[-4]&7)<<2); chkr(yyvsp[-4]); }
#line 1712 "vc.tab.c"
    break;

  case 59: /* ins: t_lea rm ',' exp '(' t_sp ')'  */
#line 73 "vc.y"
                                              { yyval = 0x0000 | (yyvsp[-5]<<2) | zoffX(yyvsp[-3]); }
#line 1718 "vc.tab.c"
    break;

  case 60: /* ins: t_lea rm ',' '(' t_sp ')'  */
#line 74 "vc.y"
                                         { yyval = 0x0000 | (yyvsp[-4]<<2) | zoffX(0); }
#line 1724 "vc.tab.c"
    break;

  case 61: /* ins: t_lui rm ',' exp  */
#line 75 "vc.y"
                                        { yyval = 0x6001 | ((8|yyvsp[-2])<<7) | luioff(yyvsp[0],0); }
#line 1730 "vc.tab.c"
    break;

  case 62: /* ins: t_li rm ',' exp  */
#line 76 "vc.y"
                                        { yyval = 0x4001 | (yyvsp[-2]<<7) | lioff(yyvsp[0]); }
#line 1736 "vc.tab.c"
    break;

  case 63: /* ins: t_beqz rm ',' t_name  */
#line 77 "vc.y"
                                        { yyval = 0xc001 | (yyvsp[-2]<<7); ref_label(yyvsp[0], 3); }
#line 1742 "vc.tab.c"
    break;

  case 64: /* ins: t_bnez rm ',' t_name  */
#line 78 "vc.y"
                                        { yyval = 0xe001 | (yyvsp[-2]<<7); ref_label(yyvsp[0], 3); }
#line 1748 "vc.tab.c"
    break;

  case 65: /* ins: t_bltz rm ',' t_name  */
#line 79 "vc.y"
                                        { yyval = 0xe003 | (yyvsp[-2]<<7); ref_label(yyvsp[0], 3); }
#line 1754 "vc.tab.c"
    break;

  case 66: /* ins: t_bgez rm ',' t_name  */
#line 80 "vc.y"
                                        { yyval = 0xc003 | (yyvsp[-2]<<7); ref_label(yyvsp[0], 3); }
#line 1760 "vc.tab.c"
    break;

  case 67: /* ins: t_j t_name  */
#line 81 "vc.y"
                                        { yyval = 0xa001; ref_label(yyvsp[0], 2); }
#line 1766 "vc.tab.c"
    break;

  case 68: /* ins: t_jal t_name  */
#line 82 "vc.y"
                                        { yyval = 0x2001; ref_label(yyvsp[0], 2); }
#line 1772 "vc.tab.c"
    break;

  case 69: /* ins: t_sll rm  */
#line 83 "vc.y"
                                        { yyval = 0x0002 | (yyvsp[0]<<7); }
#line 1778 "vc.tab.c"
    break;

  case 70: /* ins: t_srl rm  */
#line 84 "vc.y"
                                        { yyval = 0x8001 | (yyvsp[0]<<7); }
#line 1784 "vc.tab.c"
    break;

  case 71: /* ins: t_sra rm  */
#line 85 "vc.y"
                                        { yyval = 0x8401 | (yyvsp[0]<<7); }
#line 1790 "vc.tab.c"
    break;

  case 72: /* ins: t_la rm ',' t_name  */
#line 86 "vc.y"
                                        { ref_label(yyvsp[0], 4); code[pc++] = 0x6001|((8|yyvsp[-2])<<7); yyval = 0x0001 | (yyvsp[-2]<<7); ref_label(yyvsp[0], 5); }
#line 1796 "vc.tab.c"
    break;

  case 73: /* ins: '.' t_word exp  */
#line 87 "vc.y"
                                        { yyval = yyvsp[0]; }
#line 1802 "vc.tab.c"
    break;

  case 74: /* ins: '.' t_word t_name  */
#line 88 "vc.y"
                                        { yyval = 0; ref_label(yyvsp[0], 1);}
#line 1808 "vc.tab.c"
    break;

  case 75: /* ins: '.' t_word t_name '+' exp  */
#line 89 "vc.y"
                                          { yyval = yyvsp[0]; ref_label(yyvsp[-2], 1); }
#line 1814 "vc.tab.c"
    break;

  case 76: /* label: t_name ':'  */
#line 93 "vc.y"
                                        { declare_label(yyvsp[-1]); }
#line 1820 "vc.tab.c"
    break;

  case 78: /* line: label ins t_nl  */
#line 97 "vc.y"
                                        { process_op(yyvsp[-1]);  }
#line 1826 "vc.tab.c"
    break;

  case 79: /* line: ins t_nl  */
#line 98 "vc.y"
                                        { process_op(yyvsp[-1]);  }
#line 1832 "vc.tab.c"
    break;

  case 80: /* line: '.' '=' exp t_nl  */
#line 99 "vc.y"
                                        { pc = yyvsp[-1]/2; }
#line 1838 "vc.tab.c"
    break;

  case 81: /* line: '.' '=' '.' '+' exp t_nl  */
#line 100 "vc.y"
                                        { pc += yyvsp[-1]/2; }
#line 1844 "vc.tab.c"
    break;


#line 1848 "vc.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

