### Process this file with autoconf to produce a configure script.
AC_INIT([UHC-doc],[1.1.7],[uhc-developers@lists.science.uu.nl, http://www.cs.uu.nl/wiki/UHC/WebHome])

### version of autoconf used (and required)
#AC_PREREQ(2.64)

### revision
AC_REVISION($Revision: 1.26 $)

### set MAKE flag in relevant makefiles
AC_PROG_MAKE_SET
# Checks for host/target
AC_CANONICAL_HOST
dnl ** canonicalize platform names
HostPlatform=`/bin/sh $srcdir/config.sub $host` || exit 1

### check whether we are indeed in the toplevel dir, otherwise copy required stuff to the current dir first
if test "${srcdir}" != "." -a "${srcdir}" != ""
then
  # copy all the relevant stuff
  echo "copying from: ${srcdir}"
  for stuff in Makefile LICENSE VERSION mk test bin ehclib extlibs src
  do
    echo "copying into builddir: ${stuff}"
    d=`dirname ${stuff}`
    rsync --archive --update --exclude='.*' ${srcdir}/${stuff} ${d}
  done
fi

### global settings, variables, defaults
# command/msg to run when tool is absent
cmdForExitIfAbsentLibOrTool='echo "**** ERROR **** A tool or library is missing. Check ./configure summary." ; exit 1'


dnl macro for missing program
AC_DEFUN(MISSING_FOR_EH,
[
  AC_MSG_ERROR([
     You must install $1 before you can continue
     Perhaps it is already installed, but not in your PATH?])
])

dnl macro for missing program which does not stop an alternate route of installing
AC_DEFUN(MISSING_FOR_EH_BUT_CAN_GO_ON,
[
  AC_MSG_WARN([
     You should have installed $1, but I will proceed without it.
     However, this may lead to a partial install only.
     Perhaps $1 is already installed, but not in your PATH?])
])

dnl macro for required programs
AC_DEFUN(REQUIRED_PROG_FOR_EH,
[
  AC_PATH_PROG($1,$2)
  if test -z "[$]$1"; then
    ifelse([$3], , [ MISSING_FOR_EH([$2]) ], [ MISSING_FOR_EH([$3]) ])
  fi
])

dnl macro for optional required programs, that is, an alternate install route exists
AC_DEFUN(REQUIRED_OPTIONAL_PROG_FOR_EH,
[
  AC_PATH_PROG($1,$2)
  if test -z "[$]$1"; then
    ifelse([$3], , [ MISSING_FOR_EH_BUT_CAN_GO_ON([$2]) ], [ MISSING_FOR_EH_BUT_CAN_GO_ON([$3]) ])
  fi
])

### obvious utils which are amiss on some platforms: m4
REQUIRED_PROG_FOR_EH(m4Cmd,m4)

### git log/history
AC_PATH_PROG(gitCmd,git)
if test -x "$gitCmd"
then
  gitExists="yes"
  gitHash=`git rev-parse HEAD | cut -c 1-10`
  gitBranch=`git symbolic-ref HEAD`
  gitVersionExists="yes"
  echo "${gitBranch#refs/heads/}@$gitHash" > GITHASH
  gitHashCmd="cat GITHASH"
else
  gitExists="no"
  gitVersionExists="no"
  gitHashCmd="echo 'no git available'"
fi
AC_SUBST(GIT_EXISTS,$gitExists)
AC_SUBST(GIT_CMD,$gitCmd)

### git revision
gitHashVal=`${gitHashCmd}`
AC_SUBST(GIT_VERSION_EXISTS,$gitVersionExists)
AC_SUBST(GIT_VERSION_CMD,$gitHashCmd)
AC_SUBST(GIT_REVISION,$gitHashVal)

### cpp
AC_ARG_WITH(cpp,
[AS_HELP_STRING([--with-cpp=<cpp preprocessor>],[Use a command different from 'cpp' to compile with CPP.])],
[ cppCmd="$withval" ],
[
  if test "$CPP" = ""; then
    AC_PATH_PROG(cppCmd,cpp)
  else
    cppCmd=$CPP
  fi
]
)
if test "$cppCmd" != "no" -a -x "$cppCmd"; then
  cppExists="yes"
  cppVersion=`$cppCmd --version`
else
  cppCmd=""
  cppExists="no"
fi

### cat
REQUIRED_PROG_FOR_EH(catCmd,cat)
# See remarks about cpp
case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
        if test ! -x "$toplevelSystemAbsolutePathPrefix/$catCmd"
        then
          catCmd="`echo $catCmd | sed -e 's+/usr++'`"
        fi
        ;;
  *)
        ;;
esac
AC_SUBST(CAT_CMD,$catCmd)

### libtool
REQUIRED_OPTIONAL_PROG_FOR_EH(libtoolStaticCmd,libtool)

### 'with' option hardbaked choice of aspects
AC_ARG_WITH(aspects,
[AS_HELP_STRING([--with-aspects=<choice of aspects>],[Choice of aspects, can be overridden when 'make'ing.])],
[ aspects="$withval" ],)
AC_SUBST(ASPECTS, "$aspects")

### 'with' option hardbaked choice of aspects
AC_ARG_WITH(aspects,
[AS_HELP_STRING([--with-aspects=<choice of aspects>],[Choice of aspects, can be overridden when 'make'ing.])],
[ aspects="$withval" ],)
AC_SUBST(ASPECTS, "$aspects")

### 'with' option for build suffix, which by default is derived from hardbaked aspects
AC_ARG_WITH(build-suffix,
[AC_HELP_STRING([--with-build-suffix=<suffix for build locations>],
                [Suffix for build locations and library names of globally visible cabal managed libraries.])],
[ ehcBuildSuffix="$withval" ],)
if test "x$ehcBuildSuffix" = "x"
then
  ehcBuildSuffix="`echo ${ASPECTS} | sed -e 's/ /-/g'`"
fi
AC_SUBST(EHC_BUILD_SUFFIX, "$ehcBuildSuffix")

### 'with' option for uhc repo prefix, which by default is derived from hardbaked aspects
AC_ARG_WITH(uhc-repo-prefix,
[AC_HELP_STRING([--with-uhc-repo-prefix=<prefix for uhc repo location>],
                [Prefix for uhc repo as it can be found locally, the top level dir as cloned.])],
[ uhcRepoPrefix="$withval" ],)
if test "x$uhcRepoPrefix" = "x"
then
  uhcRepoPrefix="../uhc/EHC/"
else
  uhcRepoPrefix="${uhcRepoPrefix}EHC/"
fi
AC_SUBST(UHC_REPO_PREFIX, "$uhcRepoPrefix")

### 'with' option for ruler uhc examples repo prefix, which by default is derived from hardbaked aspects
AC_ARG_WITH(ruler-uhc-examples-repo-prefix,
[AC_HELP_STRING([--with-ruler-uhc-examples-repo-prefix=<prefix for ruler uhc examples repo location>],
                [Prefix for ruler uhc examples repo as it can be found locally, the top level dir as cloned.])],
[ rulerUhcExamplesRepoPrefix="$withval" ],)
if test "x$rulerUhcExamplesRepoPrefix" = "x"
then
  rulerUhcExamplesRepoPrefix="../ruler-uhc-examples/"
else
  rulerUhcExamplesRepoPrefix="${rulerUhcExamplesRepoPrefix}"
fi
AC_SUBST(RULER_UHC_EXAMPLES_REPO_PREFIX, "$rulerUhcExamplesRepoPrefix")

### 'with' option for gcc options
AC_ARG_WITH(gcc-ehc-options,
[AS_HELP_STRING([--with-gcc-ehc-options=<gcc compiler options for compiling runtime and ehc's gcc invocation>],[Additional options to pass to GCC when compiling with EHC.])],
[ gccEhcOptions="$withval" ],)

# additional platform dependend options for gcc when compiling C from within ehc
case $HostPlatform in
  i*86-pc-linux-gnu )
        #gccEhcOptions="${gccClangEhcOptions} $gccEhcOptions -D__USE_BSD -D__USE_POSIX"
        gccEhcOptions="${gccClangEhcOptions} $gccEhcOptions"
        ;;
  *)
        gccEhcOptions="${gccClangEhcOptions} $gccEhcOptions"
        ;;
esac

AC_SUBST(GCC_EHC_OPTIONS, "$gccEhcOptions")

### 'with' option for cpp options
AC_ARG_WITH(cpp-ehc-options,
[AS_HELP_STRING([--with-cpp-ehc-options=<cpp preprocessor options for ehc's cpp invocation>],[Additional options to pass to CPP when compiling with EHC.])],
[ cppEhcOptions="$withval" ],)

# additional platform dependend options for cpp when compiling C from within ehc
case $HostPlatform in
  i*86-pc-linux-gnu )
        cppEhcOptions="${cppClangEhcOptions} $cppEhcOptions -D__STDC__"
        #cppEhcOptions="$cppEhcOptions -D__USE_BSD -D__USE_POSIX -D__STDC__"
        ;;
  x86_64-*-linux-gnu )
        cppEhcOptions="${cppClangEhcOptions} $cppEhcOptions -D__STDC__"
        #cppEhcOptions="$cppEhcOptions -D__USE_BSD -D__USE_POSIX -D__STDC__"
        ;;
  *)
        cppEhcOptions="${cppClangEhcOptions}"
        ;;
esac

AC_SUBST(CPP_EHC_OPTIONS, "$cppEhcOptions")

### 'with' option for shuffle options
AC_ARG_WITH(shuffle-ehc-options,
[AS_HELP_STRING([--with-shuffle-ehc-options=<shuffle options for compiling ehc>],[Additional options to pass to SHUFFLE when compiling EHC.])],
[ shuffleEhcOptions="$withval" ],)
AC_SUBST(SHUFFLE_EHC_OPTIONS, "$shuffleEhcOptions")

### 'with' option for uuagc options
AC_ARG_WITH(uuagc-options,
[AS_HELP_STRING([--with-uuagc-options=<AG compiler options for compiling ehc>],[Additional options to pass to UUAGC when compiling EHC.])],
[ uuagcOptions="$withval" ],)
AC_SUBST(UUAGC_OPTIONS, "$uuagcOptions")

### 'with' option for uuagc options, specifically for EHC's AST
AC_ARG_WITH(uuagc-ehc-ast-options,
[AS_HELP_STRING([--with-uuagc-ehc-ast-options=<AG compiler options for compiling ehc's AST data types>],[Additional options to pass to UUAGC when compiling EHC's AST data types.])],
[ uuagcEhcAstOptions="$withval" ],)
AC_SUBST(UUAGC_EHC_AST_OPTIONS, "$uuagcEhcAstOptions")

### 'with' option for uuagc options, specifically for EHC's semantics
AC_ARG_WITH(uuagc-ehc-sem-options,
[AS_HELP_STRING([--with-uuagc-ehc-sem-options=<AG compiler options for compiling ehc's semantics>],[Additional options to pass to UUAGC when compiling EHC's AST semantics.])],
[ uuagcEhcSemOptions="$withval" ],)
AC_SUBST(UUAGC_EHC_SEM_OPTIONS, "$uuagcEhcSemOptions")

### 'with' option for shuffle options
AC_ARG_WITH(shuffle-options,
[AS_HELP_STRING([--with-shuffle-options=<shuffle options for compiling ehc>],[Additional options to pass to shuffle when compiling EHC.])],
[ shuffleOptions="$withval" ],)
AC_SUBST(SHUFFLE_OPTIONS, "$shuffleOptions")

### 'with' option for cabal config options
AC_ARG_WITH(cabal-config-options,
[AS_HELP_STRING([--with-cabal-config-options=<cabal configure options for compiling ehc>],[Additional options to pass to cabal's ./setup configure when compiling EHC.])],
[ cabalConfigureOptions="$withval" ],)
AC_SUBST(CABAL_CONFIGURE_OPTIONS, "$cabalConfigureOptions")

### 'with' option for additional ehc unixtool (gcc, cpp) prefix.
### Usually empty, but set for (e.g.) cygwin
AC_ARG_WITH(ehc-unixtool-prefix,
[AS_HELP_STRING([--with-ehc-unixtool-prefix=<additional prefix for unixtools (already with absolute pathnames) used by ehc>],[Additional prefix for unixtools used by ehc.])],
[ toplevelSystemAbsolutePathPrefix="$withval" ],)

# when no unixtool prefix is specified && running cygwin, take cygwin's equivalent of /
case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
        if test "$toplevelSystemAbsolutePathPrefix" = ""
        then
          toplevelSystemAbsolutePathPrefix="`cygpath --mixed /`"
        fi
        ;;
  *)
        ;;
esac

AC_SUBST(TOPLEVEL_SYSTEM_ABSPATH_PREFIX, "$toplevelSystemAbsolutePathPrefix")

### 'with' option for haddock
AC_ARG_WITH(haddock,
[AS_HELP_STRING([--with-haddock=<haddock>],[Use a command different from 'haddock' to generate doc.])],
[ haddockCmd="$withval" ],
[
  if test "$HADDOCK" = ""; then
    AC_PATH_PROG(haddockCmd,haddock)
  else
    haddockCmd=$HADDOCK
  fi
]
)
if test "$haddockCmd" != "no" -a -x "$haddockCmd"; then
  haddockExists="yes"
  haddockVersion=`$haddockCmd --version | head -n 1`
else
  haddockCmd=""
  haddockExists="no"
fi
AC_SUBST(HADDOCK_CMD,$haddockCmd)
AC_SUBST(HADDOCK_VERSION, $haddockVersion)

### 'with' option for Haskell compiler, by default ghc
AC_ARG_WITH(hc,
[AS_HELP_STRING([--with-hc=<haskell compiler>],[Use a command different from 'ghc' to compile with GHC.])],
[ ghcCmd="$withval" ],
[
  if test "$GHC" = ""; then
    AC_PATH_PROG(ghcCmd,ghc)
  else
    ghcCmd=$GHC
  fi
]
)
if test "$ghcCmd" != "no" -a -x "$ghcCmd" ; then
  ghcExists="yes"
  ghcVersion=`$ghcCmd --numeric-version`
else
  ghcCmd=""
  ghcExists="no"
fi
AC_SUBST(GHC_CMD,$ghcCmd)
AC_SUBST(GHC_VERSION, $ghcVersion)


### 'with' option for UHC compiler, by default uhc
AC_ARG_WITH(uhc,
[AS_HELP_STRING([--with-uhc=<UHC>],[Use a command different from 'uhc' to use UHC.])],
[ uhcCmd="$withval" ],
[
  if test "$UHC" = ""; then
    AC_PATH_PROG(uhcCmd,uhc)
  else
    uhcCmd=$UHC
  fi
]
)
if test "$uhcCmd" != "no" -a -x "$uhcCmd" ; then
  uhcExists="yes"
  uhcVersion=`$uhcCmd --version-dotted`
else
  uhcCmd=""
  uhcExists="no"
fi
AC_SUBST(UHC_CMD,$uhcCmd)
AC_SUBST(UHC_VERSION, $uhcVersion)


### 'with' option for cabal, by default cabal
AC_ARG_WITH(cabal,
[AS_HELP_STRING([--with-cabal=<cabal package installer>],[Use a command different from 'cabal' to build libraries with GHC.])],
[ cabalCmd="$withval" ],
[
  if test "$CABAL" = ""; then
    AC_PATH_PROG(cabalCmd,cabal)
  else
    cabalCmd=$CABAL
  fi
]
)
AC_SUBST(CABAL_CMD, $cabalCmd)

### 'with' option for ghc options
AC_ARG_WITH(ghc-ehc-options,
[AS_HELP_STRING([--with-ghc-ehc-options=<haskell compiler options for compiling ehc>],[Additional options to pass to GHC when compiling EHC.])],
[ ghcEhcOptions="$withval" ],)

### some options *must* be passed to ghc >= 7.xx, but *may not* be passed to earlier ones
case $ghcVersion in
  6*)
    ;;
  *)
    ghcGenOptions="$ghcGenOptions -rtsopts"
    ;;
esac

AC_SUBST(GHC_EHC_OPTIONS, "$ghcEhcOptions")
AC_SUBST(GHC_GEN_OPTIONS, "$ghcGenOptions")

case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
  ghcCmd1=`echo $ghcCmd | sed 's+^/\(cygdrive/\)\?\(.\)/+\2:/+'`
  echo "ghcCmd is $ghcCmd, raw is $ghcCmd1"
  echo $ghcCmd | sed 's+^/\(cygdrive/\)\?\(.\)/+\2:/+'
  ;;
  *)
  ghcCmd1=$ghcCmd
  ;;
esac

AC_SUBST(GHC_CMD1,$ghcCmd1)


### assuming we have ghc, check for some of the additional tools
AC_PATH_PROG(ghcPkgCmd,ghc-pkg)
AC_PATH_PROG(hsc2hsCmd,hsc2hs)
AC_SUBST(HSC2HS_CMD,$hsc2hsCmd)

### now we know we have ghc, check for some libraries using ghc-pkg
ghcLibsRequired="fgl vector uulib network binary hashable uhc-util base mtl transformers directory containers array process filepath"
#if test x$enableClr = "xyes"
#then
#  ghcLibsRequired="${ghcLibsRequired} primitive"
#fi

# gather for some libraries version info
ghcLibsRequiredWithVersion=""
ghcLibsRequiredWithoutVersion=""
if test x$ghcExists = xyes
then
  if test -x "$ghcCmd" -a -x "$ghcPkgCmd"
  then
    for pkgBase in ${ghcLibsRequired}
    do
      pkg=`$ghcPkgCmd list --simple-output ${pkgBase} | sed -e 'y/ /\n/' | tail -1`
      if test "x${pkg}" != "x" ; then
        ghcLibsRequiredAndPresent="${pkg} ${ghcLibsRequiredAndPresent}"
        pkgVersion=`echo ${pkg} | sed -E -e 's/^(([[^-]]+-)+)([[^.]]+(\.[[^.]]+)*)$/\3/'`
        pkgVersionNoDot=`echo ${pkgVersion} | sed -E -e 's/\.//'g`
        ### here do special treatment of packages, now we have name&version of packages available
        case ${pkgBase} in
          uhc-util)
            ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} uhc-util>=0.1.6.5&&<0.1.7"
            ;;
          uulib)
            ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} uulib>=0.9.19"
            ;;
          base)
            ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} base>=4.7&&<5"
            ;;
          hashable)
            ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} hashable>=1.1&&<1.3"
            ;;
          fgl)
            # with uhc-util >= 0.1.3.7 no longer necessary
            if test ${pkgVersionNoDot} -ge 5500
            then
              #ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} fgl>=5.5 graphviz"
              ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} fgl"
            else
              #ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} fgl<5.5"
              ghcLibsRequiredWithVersion="${ghcLibsRequiredWithVersion} fgl"
            fi
            ;;
          *)
            ghcLibsRequiredWithoutVersion="${ghcLibsRequiredWithoutVersion} ${pkgBase}"
            ;;
        esac
      else
        ghcLibsRequiredButAbsent="${pkgBase} ${ghcLibsRequiredButAbsent}"
      fi
    done
  fi
fi

# GHC version dependencies: packages passed as option, cabal packages
cabal_base_lib_depends="${ghcLibsRequiredWithVersion} ${ghcLibsRequiredWithoutVersion}"
if test x$enableClr = "xyes"
then
  cabal_base_lib_depends="$cabal_base_lib_depends language-cil"
fi
cabal_extra_lib_depends=""
optCabalAllowUndecidableInstances=UndecidableInstances
optStandardGHCPackages=""
# (1) GHC 6.6 and higher: no package util, lang, and data anymore
# (2) after ghc 6.4.1 the names of cabal option(s) changed
case $ghcVersion in
  6.4.1)
    optStandardGHCPackages="-package util -package lang -package data"
    optCabalAllowUndecidableInstances=AllowUndecidableInstances
    ;;
  6.4.2)
    optStandardGHCPackages="-package util -package lang -package data"
    ;;
esac

AC_SUBST(OPT_GHC_STANDARD_PACKAGES,"$optStandardGHCPackages")
AC_SUBST(CABAL_BASE_LIB_DEPENDS,"$cabal_base_lib_depends")
AC_SUBST(CABAL_EXTRA_LIB_DEPENDS,"$cabal_extra_lib_depends")
AC_SUBST(CABAL_OPT_ALLOW_UNDECIDABLE_INSTANCES,"$optCabalAllowUndecidableInstances")

# uuagc
AC_ARG_WITH(uuagc,
[AS_HELP_STRING([--with-uuagc=<uu ag compiler>],[Use a command different from 'uuagc' to compile with UUAGC.])],
[ uuagcCmd="$withval" ],
[
  if test "$UUAGC" = ""; then
    AC_PATH_PROG(uuagcCmd,uuagc)
  else
    uuagcCmd=$UUAGC
  fi
]
)
if test "$uuagcCmd" != "no" -a -x "$uuagcCmd" ; then
  uuagcExists="yes"
  uuagcVersion=`$uuagcCmd --version`
  buildToolDependenciesUnchecked="uuagc>=0.9.50.2 ${buildToolDependenciesUnchecked}"
else
  uuagcCmd=""
  uuagcExists="no"
fi
AC_SUBST(UUAGC_CMD,$uuagcCmd)

# shuffle
AC_ARG_WITH(shuffle,
[AS_HELP_STRING([--with-shuffle=<shuffle compiler>],[Use a command different from 'shuffle' to compile with shuffle.])],
[ shuffleCmd="$withval" ],
[
  if test "$SHUFFLE" = ""; then
    AC_PATH_PROG(shuffleCmd,shuffle)
  else
    shuffleCmd=$SHUFFLE
  fi
]
)
if test "$shuffleCmd" != "no" -a -x "$shuffleCmd" ; then
  shuffleExists="yes"
  shuffleVersion=`$shuffleCmd --version`
  buildToolDependenciesUnchecked="shuffle>=0.1.3.1 ${buildToolDependenciesUnchecked}"
else
  shuffleCmd=""
  shuffleExists="no"
fi
AC_SUBST(SHUFFLE_CMD,$shuffleCmd)

# ruler
AC_ARG_WITH(ruler,
[AS_HELP_STRING([--with-ruler=<ruler compiler>],[Use a command different from 'ruler' to compile with ruler.])],
[ rulerCmd="$withval" ],
[
  if test "$RULER" = ""; then
    AC_PATH_PROG(rulerCmd,ruler)
  else
    rulerCmd=$RULER
  fi
]
)
if test "$rulerCmd" != "no" -a -x "$rulerCmd" ; then
  rulerExists="yes"
  rulerVersion=`$rulerCmd --version`
  buildOptionalToolDependenciesUnchecked="ruler>=0.4.0.1 ${buildOptionalToolDependenciesUnchecked}"
else
  rulerCmd="${cmdForExitIfAbsentLibOrTool}"
  rulerExists="no"
fi
AC_SUBST(RULER_CMD,$rulerCmd)
AC_SUBST(RULER_EXISTS,$rulerExists)

# gcc
AC_ARG_WITH(gcc,
[AS_HELP_STRING([--with-gcc=<gcc compiler>],[Use a command different from 'gcc' to compile with GCC.])],
[ gccCmd="$withval" ],
[
  if test "$GCC" = ""; then
    AC_PATH_PROG(gccCmd,gcc)
  else
    gccCmd=$GCC
  fi
]
)
if test "$gccCmd" != "no" -a -x "$gccCmd" ; then
  gccExists="yes"
  gccVersion=`$gccCmd -dumpversion`
else
  gccCmd=""
  gccExists="no"
fi

# See remarks about cpp
case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
        if test ! -x "$toplevelSystemAbsolutePathPrefix/$gccCmd"
        then
          gccCmd="`echo $gccCmd | sed -e 's+/usr++'`"
          if test -L "$toplevelSystemAbsolutePathPrefix/$gccCmd"
          then
            gccCmd="$gccCmd-3"
          fi
        fi
        ;;
  *)
        ;;
esac

AC_SUBST(GCC_CMD,$gccCmd)

AC_RUN_IFELSE([AC_LANG_PROGRAM(
[[#include <stdio.h>]], [[
FILE *fp;
fp = fopen("conftest.cc", "w");
if (fp == 0) return(1);
fprintf(fp, "cc_major_version=%d;cc_minor_version=%d;cc_patch_version=%d",
__GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
fclose(fp);
]])],
[eval `cat conftest.cc`],
[cc_major_version=no],
)

AC_MSG_CHECKING([Version of $CC])
if test "$cc_major_version" = "no"; then
  AC_MSG_RESULT([no])
  AC_MSG_FAILURE([Requires that $CC is usable], [1])
else
  cc_version="$cc_major_version.$cc_minor_version.$cc_patch_version"
  AC_MSG_RESULT([$cc_version])
fi

case $cc_version in
  4.0.1)
    cc_std_flag="-std=gnu99"
    ;;
  *)
    cc_std_flag="-std=gnu99"
    ;;
esac
AC_SUBST(CC_STD_FLAG,$cc_std_flag)

# Now we have to deal with weird cygwin behaviour which allows /usr/bin to be used
# whereas in reality it is mapped onto /bin. Direct acccess to /usr/bin with a c:/cygwin prefix therefore does not work
# and has to be stripped of the /usr part.
# Then, the resulting filename may refer to a symbolic link. If so, Try to dereference it by postfixing -3, that is cpp becomes cpp-3
# For other tools like gcc we have to this too.
case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
    if test ! -x "$toplevelSystemAbsolutePathPrefix/$cppCmd"
    then
      cppCmd="`echo $cppCmd | sed -e 's+/usr++'`"
      if test -L "$toplevelSystemAbsolutePathPrefix/$cppCmd"
      then
        cppCmd="$cppCmd-3"
      fi
    fi
    ;;
  *)
    ;;
esac

AC_SUBST(CPP_CMD,$cppCmd)


# md5
AC_PATH_PROG(md5Cmd,md5 md5sum)
AC_SUBST(MD5_CMD,$md5Cmd)

# (gnu)tar; gnutar is required, but sometimes it already is available as tar
AC_CHECK_PROGS(tarCmd,gnutar tar)
AC_SUBST(TAR_CMD,$tarCmd)

# xxx
#AC_PATH_PROG(xxxCmd,xxx)
#echo xxxCmd: $xxxCmd

### Checks for libraries.

### Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

### what to make
#AC_SUBST(UUST_SUBDIRS,"shc lib")

### header & function presence

### general configuration

### machine dependent code


case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
        ;;
  powerpc-apple-* )
        ;;
  i*86-pc-linux-gnu )
        gcc_ehc_extra_extern_libs="pthread"
        ;;
  *-linux-gnu )
        gcc_ehc_extra_extern_libs="pthread"
        ;;
  x86_64-* )
        ;;
  i386-apple-* )
        ;;
  *)
        ;;
esac
AC_SUBST(GCC_EHC_EXTRA_EXTERN_LIBS,"$gcc_ehc_extra_extern_libs")
### other platform specific stuff
# defaults:
# file suffixes
suffix_shell=""
suffix_exec=""
suffix_libC=".a"
suffix_libJavaScript=".mjs"
prefix_lib=""
# development platform
development_platform="UNIX"
host_platform="$host"
# path separator
paths_sep=":"
slash="/"
# libtool usage
#libtoolStaticCmd="libtool"
libtoolStaticOpts="-static -o"
libtoolDynamicCmd="echo Dynamic linking not available: "
libtoolDynamicOpts=""
ehcGccOptsStatic=""
linker_symbol_prefix="_"

case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
        # file suffixes
        suffix_shell=".bat"
        suffix_exec=".exe"
        #suffix_libC=".lib"
        #prefix_lib="lib"
        development_platform="CYGWIN"
        # path separator
        paths_sep=";"
        slash="\\\\"
        # libtool usage
        libtoolStaticCmd="no"
        ;;
  i*86-pc-linux-gnu )
        # file suffixes
        # path separator
        # libtool usage
        #libtoolStaticCmd="no"
        # ehcGccOptsStatic="-static"
	    # libtoolStaticCmd="libttcflagool --mode=link gcc -static -o"
        libtoolStaticCmd="no"
        linker_symbol_prefix=""
        ;;
  x86*-*-linux-gnu )
        # file suffixes
        # path separator
        # libtool usage
        # libtoolStaticCmd="libtool --mode=link gcc -static -o"
        libtoolStaticCmd="no"
        ;;
  *)
        # file suffixes
        # path separator
        # libtool usage
        ;;
esac
# suffixes, path separator, ...
AC_SUBST(SUFFIX_SHELL,"$suffix_shell")
AC_SUBST(SUFFIX_EXEC,"$suffix_exec")
AC_SUBST(SUFFIX_LIBC,"$suffix_libC")
AC_SUBST(SUFFIX_LIBJS,"$suffix_libJavaScript")
AC_SUBST(PREFIX_LIB,"$prefix_lib")
AC_SUBST(PATHS_SEP,"$paths_sep")
AC_SUBST(SLASH,"$slash")
AC_SUBST(LINKER_SYMBOL_PREFIX,"$linker_symbol_prefix")

# misc
AC_SUBST(DEVELOPMENT_PLATFORM,"$development_platform")
AC_SUBST(HOST_PLATFORM,"$host_platform")
AC_SUBST(NRWORDBITS_PLATFORM,"$nrwordbits_platform")

# libtool used, if any
AC_SUBST(LIBTOOL_STATIC_CMD, "$libtoolStaticCmd")
AC_SUBST(LIBTOOL_STATIC_OPTS, "$libtoolStaticOpts")
AC_SUBST(LIBTOOL_DYNAMIC_CMD, "$libtoolDynamic")
AC_SUBST(LIBTOOL_DYNAMIC_OPTS, "$libtoolDynamicOpts")

# flags passed to gcc by ehc related to static/dynamic libraries
AC_SUBST(EHC_GCC_OPTS_STATIC, "$ehcGccOptsStatic")

### absolute path to this dir
hardtop=`pwd`
hardtop=`echo $hardtop | sed 's|^/tmp_mnt.*\(/local/.*\)$|\1|' | sed 's|^/tmp_mnt/|/|' | sed 's|^/grasp_tmp|/local/grasp_tmp|' | sed 's|^//\(.\)/|\1:/|' `
#
# The native format for 'hardtop' (i.e., right kind of slashes on a Win32 box).
# (but with b-slashes being escaped).
case $HostPlatform in
  i*86-*-mingw* | i*86-*-cygwin* )
        # get rid off /cygdrive/ prefix
        hardtop=`echo ${hardtop} | sed -e 's%^/cygdrive/\(.\)/%\1:/%' `
        hardtop_plat=`cygpath -w ${hardtop} | sed -e 's@\\\\@/@g' `
        hardtop_plat2=${hardtop}
        shellrun="/bin/bash "
        ;;
  *-*-msys)
        # convert the root POSIX path to Windows paths so cabal can find the paths.
        # internally these will be converted back to posix paths by the msys shell
        # to prevent issues with escaping just transform the root e.g /c/ to c:/
        # Windows natively supports both \ and / for paths so this is not an issue
        hardtop_plat=`echo ${hardtop} | sed -e 's%^/%%' -e 's%^.%\0:%' `
        hardtop_plat2=`echo ${hardtop} | sed -e 's%^/%%' -e 's%^.%\0:%' `
        shellrun=""
        ;;
  *)
        hardtop_plat=${hardtop}
        hardtop_plat2=${hardtop}
        shellrun=""
        ;;
esac
AC_SUBST(TOP_ABS, "$hardtop_plat")
AC_SUBST(TOP_ABS2, "$hardtop_plat2")
AC_SUBST(SHELLRUN, "$shellrun")

### Platform information, needed for LLVM code generation
AC_SUBST(TARGET_TRIPLE, "$host")

### names of compiler executables
AC_SUBST(EHC_EXEC_NAME, "ehc")
AC_SUBST(UHC_EXEC_NAME, "uhc")

### name of subdirectory for shared ehc library artifacts
AC_SUBST(EHCLIB_SHARED, "shared")

### install locations
inplaceInstallDir="install"
inplaceInstallForBldDir="install-for-build"
AC_SUBST(INPLACE_TOP, "$hardtop")
AC_SUBST(INPLACE_PREFIX, "$hardtop_plat/$inplaceInstallDir")
AC_SUBST(INPLACE_INSTALL_DIR, "$inplaceInstallDir")
AC_SUBST(INPLACE_INSTALLFORBLD_DIR, "$inplaceInstallForBldDir")
AC_SUBST(INSTALL_LIB_SUFFIX, "lib/uhc")

### if some of the required libraries/tools are absent, this def will check for it and exit when make is invoked
if test "x$uuagcExists" = "xyes" \
   -a "x$shuffleExists" = "xyes" \
   -a "x$ghcExists" = "xyes" \
   -a "x$uhcExists" = "xyes" \
   -a "x$gccExists" = "xyes" \
   -a "x$ghcLibsRequiredButAbsent" = "x"
then
  exitIfAbsentLibOrTool=""
else
  exitIfAbsentLibOrTool="${cmdForExitIfAbsentLibOrTool}"
fi
AC_SUBST(EXIT_IF_ABSENT_LIB_OR_TOOL, $exitIfAbsentLibOrTool)

### file generation
AC_CONFIG_FILES([mk/config.mk mk/shared.mk])
AC_CONFIG_FILES([text/UHCInfo.cltex])
AC_CONFIG_FILES([src/text2text/text2text.cabal])

AC_OUTPUT

echo
echo "Installation/build summary."
echo "  host                          : $host"
echo "  prefix                        : $prefix"

echo "Required:"
echo "  uuagc is available?           : $uuagcExists"
if test "x$uuagcExists" = "xyes" ;then
echo "    version                     : $uuagcVersion"
echo "    command for uuagc           : $uuagcCmd"
else
echo "    **** ERROR **** : uuagc must be installed, use (1) cabal+hackage, or (2) http://www.cs.uu.nl/wiki/HUT"
fi

echo "  shuffle is available?         : $shuffleExists"
if test "x$shuffleExists" = "xyes" ;then
echo "    version                     : $shuffleVersion"
echo "    command for shuffle         : $shuffleCmd"
else
echo "    **** ERROR **** : shuffle must be installed, use (1) cabal+hackage, or (2) http://www.cs.uu.nl/wiki/HUT"
fi

echo "  ghc is available?             : $ghcExists"
if test "x$ghcExists" = "xyes" ;then
echo "    version                     : $ghcVersion"
echo "    command for ghc             : $ghcCmd"
echo "    command for ghc raw         : $ghcCmd1"
echo "    libraries:"
echo "      required and present      : $ghcLibsRequiredAndPresent"
  if test "x$ghcLibsRequiredButAbsent" != "x"
  then
    echo "      required but absent!!!    : $ghcLibsRequiredButAbsent"
    echo "        **** ERROR ****         : these libraries must be installed, use (1) cabal+hackage, or (2) http://www.cs.uu.nl/wiki/HUT"
  fi
else
echo "    **** ERROR **** : ghc must be installed, see http://www.haskell.org/ghc"
fi

echo "  uhc is available?             : $uhcExists"
if test "x$uhcExists" = "xyes" ;then
echo "    version                     : $uhcVersion"
echo "    command for uhc             : $uhcCmd"
else
echo "    **** ERROR **** : uhc must be installed"
fi

echo "  gcc is available?             : $gccExists"
if test "x$gccExists" = "xyes" ;then
echo "    version                     : $gccVersion"
echo "    command for gcc             : $gccCmd"
echo "    uhc options to gcc          : $gccEhcOptions"
else
echo "    **** ERROR **** : gcc must be installed, ask your OS guru"
fi

echo "  cpp is available?             : $cppExists"
if test "x$cppExists" = "xyes" ;then
echo "    version                     : `echo $cppVersion`"
echo "    command for cpp             : $cppCmd"
echo "    uhc options to cpp          : $cppEhcOptions"
else
echo "    **** ERROR **** : cpp must be installed, ask your OS guru"
fi

if test x$enableJava = xyes
then
  echo "  javac is available?           : $javacExists"
  if test "x$javacExists" = "xyes" ;then
  echo "    command for javac           : $javacCmd"
  fi
fi

echo "Required (or optional) but not (yet) or during build enforced:"
echo "  cabal base dependencies       : $cabal_base_lib_depends"
echo "  cabal extra dependencies      : $cabal_extra_lib_depends"
echo "  build tool dependencies       : $buildToolDependenciesUnchecked"
echo "  (optional) build tool dpdcies : $buildOptionalToolDependenciesUnchecked"

echo "Other:"
echo "  haddock is available?         : $haddockExists"
if test "x$haddockExists" = "xyes" ;then
echo "    version                     : $haddockVersion"
echo "    command for haddock         : $haddockCmd"
fi
echo "  ruler is available?           : $rulerExists"
if test "x$rulerExists" = "xyes" ;then
echo "    version                     : $rulerVersion"
echo "    command for ruler           : $rulerCmd"
fi

echo "Absolute location of directories:"
echo "  uhc repository prefix         : ${uhcRepoPrefix}"
echo "  ruler uhc examples repo prefix: ${rulerUhcExamplesRepoPrefix}"
echo "  ehc repository                : $hardtop_plat2"
echo "  ehc repository raw            : $hardtop_plat"
echo "  unix root prefix raw          : $toplevelSystemAbsolutePathPrefix"
