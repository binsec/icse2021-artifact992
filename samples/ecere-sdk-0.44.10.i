;

# 1176 "obj/release.linux/LFBDisplayDriver.c"
typedef signed int FT_Int32;

# 1184 "obj/release.linux/LFBDisplayDriver.c"
static __inline__ FT_Int32 FT_MulFix_i386(FT_Int32 a, FT_Int32 b)
{
register FT_Int32 result;

__asm__ volatile("imul  %%edx\nmovl  %%edx, %%ecx\nsarl  $31, %%ecx\naddl  $0x8000, %%ecx\naddl  %%ecx, %%eax\nadcl  $0, %%edx\nshrl  $16, %%eax\nshll  $16, %%edx\naddl  %%edx, %%eax\n":"=a"(result),"=d"(b):"a"(a),"d"(b):"%ecx","cc");

return result;
}

# 11 "obj/vanilla.linux/XInterface.c"
typedef unsigned long long uint64;

# 100 "obj/vanilla.linux/XInterface.c"
typedef unsigned int uintptr_t;

# 167 "obj/vanilla.linux/XInterface.c"
typedef long int __time_t;

# 171 "obj/vanilla.linux/XInterface.c"
typedef long int __suseconds_t;

# 306 "obj/vanilla.linux/XInterface.c"
struct timeval
{
__time_t tv_sec;
__suseconds_t tv_usec;
};

# 314 "obj/vanilla.linux/XInterface.c"
typedef long int __fd_mask;

# 316 "obj/vanilla.linux/XInterface.c"
typedef struct
{
__fd_mask __fds_bits[32];
} fd_set;

# 1646 "obj/vanilla.linux/XInterface.c"
typedef union
{
char __size[16];
long int __align;
} sem_t;

# 1674 "obj/vanilla.linux/XInterface.c"
typedef unsigned long XID;

# 1678 "obj/vanilla.linux/XInterface.c"
typedef unsigned long Atom;

# 1680 "obj/vanilla.linux/XInterface.c"
typedef unsigned long VisualID;

# 1682 "obj/vanilla.linux/XInterface.c"
typedef unsigned long X11Time;

# 1684 "obj/vanilla.linux/XInterface.c"
typedef XID X11Window;

# 1694 "obj/vanilla.linux/XInterface.c"
typedef XID Colormap;

# 1706 "obj/vanilla.linux/XInterface.c"
typedef char * XPointer;

# 1708 "obj/vanilla.linux/XInterface.c"
typedef struct _XExtData
{
int number;
struct _XExtData * next;
int (* free_private)(struct _XExtData * extension);
XPointer private_data;
} XExtData;

# 1758 "obj/vanilla.linux/XInterface.c"
typedef struct _XGC * GC;

# 1760 "obj/vanilla.linux/XInterface.c"
typedef struct
{
XExtData * ext_data;
VisualID visualid;
int _class;
unsigned long red_mask, green_mask, blue_mask;
int bits_per_rgb;
int map_entries;
} Visual;

# 1770 "obj/vanilla.linux/XInterface.c"
typedef struct
{
int depth;
int nvisuals;
Visual * visuals;
} Depth;

# 1777 "obj/vanilla.linux/XInterface.c"
struct _XDisplay;

# 1779 "obj/vanilla.linux/XInterface.c"
typedef struct
{
XExtData * ext_data;
struct _XDisplay * display;
X11Window root;
int width, height;
int mwidth, mheight;
int ndepths;
Depth * depths;
int root_depth;
Visual * root_visual;
GC default_gc;
Colormap cmap;
unsigned long white_pixel;
unsigned long black_pixel;
int max_maps, min_maps;
int backing_store;
int save_unders;
long root_input_mask;
} Screen;

# 1800 "obj/vanilla.linux/XInterface.c"
typedef struct
{
XExtData * ext_data;
int depth;
int bits_per_pixel;
int scanline_pad;
} ScreenFormat;

# 1969 "obj/vanilla.linux/XInterface.c"
typedef struct _XDisplay X11Display;

# 1971 "obj/vanilla.linux/XInterface.c"
struct _XPrivate;

# 1973 "obj/vanilla.linux/XInterface.c"
struct _XrmHashBucketRec;

# 1975 "obj/vanilla.linux/XInterface.c"
typedef struct
{
XExtData * ext_data;
struct _XPrivate * private1;
int fd;
int private2;
int proto_major_version;
int proto_minor_version;
char * vendor;
XID private3;
XID private4;
XID private5;
int private6;
XID (* resource_alloc)(struct _XDisplay *);
int byte_order;
int bitmap_unit;
int bitmap_pad;
int bitmap_bit_order;
int nformats;
ScreenFormat * pixmap_format;
int private8;
int release;
struct _XPrivate * private9, * private10;
int qlen;
unsigned long last_request_read;
unsigned long request;
XPointer private11;
XPointer private12;
XPointer private13;
XPointer private14;
unsigned max_request_size;
struct _XrmHashBucketRec * db;
int (* private15)(struct _XDisplay *);
char * display_name;
int default_screen;
int nscreens;
Screen * screens;
unsigned long motion_buffer;
unsigned long private16;
int min_keycode;
int max_keycode;
XPointer private17;
XPointer private18;
int private19;
char * xdefaults;
} * _XPrivDisplay;

# 2321 "obj/vanilla.linux/XInterface.c"
typedef struct
{
int type;
unsigned long serial;
int send_event;
X11Display * display;
X11Window window;
Atom atom;
X11Time time;
int state;
} XPropertyEvent;

# 11428 "obj/vanilla.linux/XInterface.c"
void * __ecereNameSpace__ecere__gui__drivers__xGlobalDisplay;

# 11436 "obj/vanilla.linux/XInterface.c"
static unsigned int __ecereNameSpace__ecere__gui__drivers__xTerminate;

# 11438 "obj/vanilla.linux/XInterface.c"
static struct __ecereNameSpace__ecere__sys__Semaphore * __ecereNameSpace__ecere__gui__drivers__xSemaphore;

# 11440 "obj/vanilla.linux/XInterface.c"
static struct __ecereNameSpace__ecere__sys__Mutex * __ecereNameSpace__ecere__gui__drivers__xMutex;

# 11452 "obj/vanilla.linux/XInterface.c"
static unsigned int __ecereNameSpace__ecere__gui__drivers__gotAnXEvent = 0;

# 11464 "obj/vanilla.linux/XInterface.c"
static Atom __ecereNameSpace__ecere__gui__drivers__atoms[47];

# 11535 "obj/vanilla.linux/XInterface.c"
static int __ecereNameSpace__ecere__gui__drivers__frameExtentSupported;

# 11537 "obj/vanilla.linux/XInterface.c"
static double __ecereNameSpace__ecere__gui__drivers__frameExtentRequest;

# 11539 "obj/vanilla.linux/XInterface.c"
static X11Window __ecereNameSpace__ecere__gui__drivers__frameExtentWindow;

# 11541 "obj/vanilla.linux/XInterface.c"
static unsigned int __ecereNameSpace__ecere__gui__drivers__timerDelay = (((int)0x7fffffff));

# 11765 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__sys__BTNode;

# 11767 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__sys__OldList
{
void * first;
void * last;
int count;
unsigned int offset;
unsigned int circ;
};

# 11776 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__DataValue
{
union
{
char c;
unsigned char uc;
short s;
unsigned short us;
int i;
unsigned int ui;
void * p;
float f;
double d;
long long i64;
uint64 ui64;
} __anon1;
};

# 11895 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__sys__Semaphore
{
sem_t semaphore;
int initCount;
int maxCount;
};

# 11904 "obj/vanilla.linux/XInterface.c"
extern double __ecereNameSpace__ecere__sys__GetTime(void);

# 12092 "obj/vanilla.linux/XInterface.c"
void __ecereMethod___ecereNameSpace__ecere__sys__Mutex_Wait(struct __ecereNameSpace__ecere__sys__Mutex * this);

# 12094 "obj/vanilla.linux/XInterface.c"
void __ecereMethod___ecereNameSpace__ecere__sys__Mutex_Release(struct __ecereNameSpace__ecere__sys__Mutex * this);

# 12136 "obj/vanilla.linux/XInterface.c"
void __ecereMethod___ecereNameSpace__ecere__sys__Semaphore_Wait(struct __ecereNameSpace__ecere__sys__Semaphore * this);

# 12273 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__Instance
{
void * * _vTbl;
struct __ecereNameSpace__ecere__com__Class * _class;
int _refCount;
};

# 12465 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__Property
{
struct __ecereNameSpace__ecere__com__Property * prev;
struct __ecereNameSpace__ecere__com__Property * next;
const char * name;
unsigned int isProperty;
int memberAccess;
int id;
struct __ecereNameSpace__ecere__com__Class * _class;
const char * dataTypeString;
struct __ecereNameSpace__ecere__com__Class * dataTypeClass;
struct __ecereNameSpace__ecere__com__Instance * dataType;
void (* Set)(void * , int);
int (* Get)(void * );
unsigned int (* IsSet)(void * );
void * data;
void * symbol;
int vid;
unsigned int conversion;
unsigned int watcherOffset;
const char * category;
unsigned int compiled;
unsigned int selfWatchable;
unsigned int isWatchable;
};

# 12519 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__sys__BinaryTree
{
struct __ecereNameSpace__ecere__sys__BTNode * root;
int count;
int (* CompareKey)(struct __ecereNameSpace__ecere__sys__BinaryTree * tree, uintptr_t a, uintptr_t b);
void (* FreeKey)(void * key);
};

# 12529 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__DataMember
{
struct __ecereNameSpace__ecere__com__DataMember * prev;
struct __ecereNameSpace__ecere__com__DataMember * next;
const char * name;
unsigned int isProperty;
int memberAccess;
int id;
struct __ecereNameSpace__ecere__com__Class * _class;
const char * dataTypeString;
struct __ecereNameSpace__ecere__com__Class * dataTypeClass;
struct __ecereNameSpace__ecere__com__Instance * dataType;
int type;
int offset;
int memberID;
struct __ecereNameSpace__ecere__sys__OldList members;
struct __ecereNameSpace__ecere__sys__BinaryTree membersAlpha;
int memberOffset;
short structAlignment;
short pointerAlignment;
};

# 12555 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__ClassTemplateArgument
{
union
{
struct
{
const char * dataTypeString;
struct __ecereNameSpace__ecere__com__Class * dataTypeClass;
} __anon1;
struct __ecereNameSpace__ecere__com__DataValue expression;
struct
{
const char * memberString;
union
{
struct __ecereNameSpace__ecere__com__DataMember * member;
struct __ecereNameSpace__ecere__com__Property * prop;
struct __ecereNameSpace__ecere__com__Method * method;
} __anon1;
} __anon2;
} __anon1;
};

# 12578 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__Method
{
const char * name;
struct __ecereNameSpace__ecere__com__Method * parent;
struct __ecereNameSpace__ecere__com__Method * left;
struct __ecereNameSpace__ecere__com__Method * right;
int depth;
int (* function)();
int vid;
int type;
struct __ecereNameSpace__ecere__com__Class * _class;
void * symbol;
const char * dataTypeString;
struct __ecereNameSpace__ecere__com__Instance * dataType;
int memberAccess;
};

# 12683 "obj/vanilla.linux/XInterface.c"
extern struct __ecereNameSpace__ecere__com__Instance * __ecereNameSpace__ecere__gui__guiApp;

# 12775 "obj/vanilla.linux/XInterface.c"
void __ecereMethod___ecereNameSpace__ecere__gui__GuiApplication_SignalEvent(struct __ecereNameSpace__ecere__com__Instance * this);

# 12884 "obj/vanilla.linux/XInterface.c"
static unsigned int __ecereNameSpace__ecere__gui__drivers__XTimerThread(struct __ecereNameSpace__ecere__com__Instance * thread)
{
int s = (*((_XPrivDisplay)__ecereNameSpace__ecere__gui__drivers__xGlobalDisplay)).fd;

for(; ; )
{
fd_set readSet, writeSet, exceptSet;
struct timeval tv =
{
(__ecereNameSpace__ecere__gui__drivers__timerDelay == (((int)0x7fffffff))) ? 0 : (__ecereNameSpace__ecere__gui__drivers__timerDelay / 1000000), (__ecereNameSpace__ecere__gui__drivers__timerDelay == (((int)0x7fffffff))) ? (int)((double)1000000 / 18.2) : (__ecereNameSpace__ecere__gui__drivers__timerDelay % 1000000)
};

if(__ecereNameSpace__ecere__gui__drivers__xTerminate)
break;
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&readSet)).__fds_bits[0]):"memory");

}while(0);
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&writeSet)).__fds_bits[0]):"memory");

}while(0);
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&exceptSet)).__fds_bits[0]):"memory");

}while(0);
((void)((*(&readSet)).__fds_bits[((s) / (8 * (int)sizeof(__fd_mask)))] |= ((__fd_mask)1 << ((s) % (8 * (int)sizeof(__fd_mask))))));
((void)((*(&exceptSet)).__fds_bits[((s) / (8 * (int)sizeof(__fd_mask)))] |= ((__fd_mask)1 << ((s) % (8 * (int)sizeof(__fd_mask))))));
__ecereMethod___ecereNameSpace__ecere__sys__Mutex_Wait(__ecereNameSpace__ecere__gui__drivers__xMutex);
if(select(s + 1, &readSet, (((void *)0)), (((void *)0)), &tv))
{
if((((*(&readSet)).__fds_bits[((s) / (8 * (int)sizeof(__fd_mask)))] & ((__fd_mask)1 << ((s) % (8 * (int)sizeof(__fd_mask))))) != 0))
__ecereNameSpace__ecere__gui__drivers__gotAnXEvent = 1;
}
if(__ecereNameSpace__ecere__gui__drivers__frameExtentSupported == 0 && __ecereNameSpace__ecere__gui__drivers__frameExtentRequest && __ecereNameSpace__ecere__sys__GetTime() - __ecereNameSpace__ecere__gui__drivers__frameExtentRequest > 1)
{
XPropertyEvent event =
{
0
};

event.type = 28;
event.state = 0;
event.atom = __ecereNameSpace__ecere__gui__drivers__atoms[34];
event.display = __ecereNameSpace__ecere__gui__drivers__xGlobalDisplay;
event.serial = 0;
event.window = __ecereNameSpace__ecere__gui__drivers__frameExtentWindow;
event.send_event = 1;
__ecereNameSpace__ecere__gui__drivers__frameExtentSupported = 2;
XSendEvent(__ecereNameSpace__ecere__gui__drivers__xGlobalDisplay, __ecereNameSpace__ecere__gui__drivers__frameExtentWindow, 0x0, (1L << 22), (union _XEvent *)&event);
}
__ecereMethod___ecereNameSpace__ecere__sys__Mutex_Release(__ecereNameSpace__ecere__gui__drivers__xMutex);
__ecereMethod___ecereNameSpace__ecere__gui__GuiApplication_SignalEvent(__ecereNameSpace__ecere__gui__guiApp);
__ecereMethod___ecereNameSpace__ecere__sys__Semaphore_Wait(__ecereNameSpace__ecere__gui__drivers__xSemaphore);
}
return 0;
}

# 13481 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__NameSpace
{
const char * name;
struct __ecereNameSpace__ecere__com__NameSpace * btParent;
struct __ecereNameSpace__ecere__com__NameSpace * left;
struct __ecereNameSpace__ecere__com__NameSpace * right;
int depth;
struct __ecereNameSpace__ecere__com__NameSpace * parent;
struct __ecereNameSpace__ecere__sys__BinaryTree nameSpaces;
struct __ecereNameSpace__ecere__sys__BinaryTree classes;
struct __ecereNameSpace__ecere__sys__BinaryTree defines;
struct __ecereNameSpace__ecere__sys__BinaryTree functions;
};

# 13495 "obj/vanilla.linux/XInterface.c"
struct __ecereNameSpace__ecere__com__Class
{
struct __ecereNameSpace__ecere__com__Class * prev;
struct __ecereNameSpace__ecere__com__Class * next;
const char * name;
int offset;
int structSize;
void * * _vTbl;
int vTblSize;
unsigned int (* Constructor)(void * );
void (* Destructor)(void * );
int offsetClass;
int sizeClass;
struct __ecereNameSpace__ecere__com__Class * base;
struct __ecereNameSpace__ecere__sys__BinaryTree methods;
struct __ecereNameSpace__ecere__sys__BinaryTree members;
struct __ecereNameSpace__ecere__sys__BinaryTree prop;
struct __ecereNameSpace__ecere__sys__OldList membersAndProperties;
struct __ecereNameSpace__ecere__sys__BinaryTree classProperties;
struct __ecereNameSpace__ecere__sys__OldList derivatives;
int memberID;
int startMemberID;
int type;
struct __ecereNameSpace__ecere__com__Instance * module;
struct __ecereNameSpace__ecere__com__NameSpace * nameSpace;
const char * dataTypeString;
struct __ecereNameSpace__ecere__com__Instance * dataType;
int typeSize;
int defaultAlignment;
void (* Initialize)();
int memberOffset;
struct __ecereNameSpace__ecere__sys__OldList selfWatchers;
const char * designerClass;
unsigned int noExpansion;
const char * defaultProperty;
unsigned int comRedefinition;
int count;
int isRemote;
unsigned int internalDecl;
void * data;
unsigned int computeSize;
short structAlignment;
short pointerAlignment;
int destructionWatchOffset;
unsigned int fixed;
struct __ecereNameSpace__ecere__sys__OldList delayedCPValues;
int inheritanceAccess;
const char * fullName;
void * symbol;
struct __ecereNameSpace__ecere__sys__OldList conversions;
struct __ecereNameSpace__ecere__sys__OldList templateParams;
struct __ecereNameSpace__ecere__com__ClassTemplateArgument * templateArgs;
struct __ecereNameSpace__ecere__com__Class * templateClass;
struct __ecereNameSpace__ecere__sys__OldList templatized;
int numParams;
unsigned int isInstanceClass;
unsigned int byValueSystemClass;
};

# 452 "obj/vanilla.linux/memory.c"
void __ecereNameSpace__ecere__sys__CopyBytes(void * dest, const void * source, unsigned int count)
{
__asm__ volatile("movl %0, %%esi\n\tmovl %1, %%edi\n\tmovl %2, %%ecx\n\trep\n\tmovsb\n\t"::"g"(source),"g"(dest),"g"(count):"ecx","esi","edi","memory");

}

# 458 "obj/vanilla.linux/memory.c"
void __ecereNameSpace__ecere__sys__CopyBytesBy2(void * dest, const void * source, unsigned int count)
{
__asm__ volatile("movl %0, %%esi\n\tmovl %1, %%edi\n\tmovl %2, %%ecx\n\trep\n\tmovsw\n\t"::"g"(source),"g"(dest),"g"(count):"cx","si","di","memory");

}

# 464 "obj/vanilla.linux/memory.c"
void __ecereNameSpace__ecere__sys__CopyBytesBy4(void * dest, const void * source, unsigned int count)
{
__asm__ volatile("movl %0, %%esi\n\tmovl %1, %%edi\n\tmovl %2, %%ecx\n\trep\n\tmovsl\n\t"::"g"(source),"g"(dest),"g"(count):"cx","si","di","memory");

}

# 470 "obj/vanilla.linux/memory.c"
void __ecereNameSpace__ecere__sys__FillBytes(void * area, unsigned char value, unsigned int count)
{
__asm__ volatile("movl %0, %%edi\n\tmovl %1, %%ecx\n\tmovb %2, %%al\n\trep\n\tstosb\n\t"::"g"(area),"g"(count),"g"(value):"ax","cx","di","memory");

}

# 476 "obj/vanilla.linux/memory.c"
void __ecereNameSpace__ecere__sys__FillBytesBy2(void * area, unsigned short value, unsigned int count)
{
__asm__ volatile("movl %0, %%edi\n\tmovl %1, %%ecx\n\tmovw %2, %%ax\n\trep\n\tstosw\n\t"::"g"(area),"g"(count),"g"(value):"ax","cx","di","memory");

}

# 482 "obj/vanilla.linux/memory.c"
void __ecereNameSpace__ecere__sys__FillBytesBy4(void * area, unsigned int value, unsigned int count)
{
__asm__ volatile("movl %0, %%edi\n\tmovl %1, %%ecx\n\tmovl %2, %%eax\n\trep\n\tstosl\n\t"::"g"(area),"g"(count),"g"(value):"ax","cx","di","memory");

}

# 60 "obj/release.linux/Service.c"
typedef unsigned short int uint16_t;

# 62 "obj/release.linux/Service.c"
typedef unsigned int uint32_t;

# 211 "obj/release.linux/Service.c"
typedef unsigned int __socklen_t;

# 491 "obj/release.linux/Service.c"
typedef __socklen_t socklen_t;

# 499 "obj/release.linux/Service.c"
extern int close(int __fd);

# 747 "obj/release.linux/Service.c"
typedef unsigned short int sa_family_t;

# 749 "obj/release.linux/Service.c"
struct sockaddr
{
sa_family_t sa_family;
char sa_data[14];
};

# 840 "obj/release.linux/Service.c"
extern int accept(int __fd, struct sockaddr * __restrict __addr, socklen_t * __restrict __addr_len);

# 848 "obj/release.linux/Service.c"
typedef uint32_t in_addr_t;

# 850 "obj/release.linux/Service.c"
struct in_addr
{
in_addr_t s_addr;
};

# 885 "obj/release.linux/Service.c"
typedef uint16_t in_port_t;

# 906 "obj/release.linux/Service.c"
struct sockaddr_in
{
sa_family_t sin_family;
in_port_t sin_port;
struct in_addr sin_addr;
unsigned char sin_zero[8];
};

# 1613 "obj/release.linux/Service.c"
typedef int SOCKET;

# 1617 "obj/release.linux/Service.c"
typedef struct sockaddr SOCKADDR;

# 1619 "obj/release.linux/Service.c"
typedef struct sockaddr_in SOCKADDR_IN;

# 1874 "obj/release.linux/Service.c"
struct __ecereNameSpace__ecere__net__Service
{
int port;
struct __ecereNameSpace__ecere__com__Instance * prev, * next;
SOCKET s;
struct __ecereNameSpace__ecere__sys__OldList sockets;
unsigned int destroyed;
unsigned int accepted;
unsigned int processAlone;
};

# 1885 "obj/release.linux/Service.c"
int __ecereVMethodID___ecereNameSpace__ecere__net__Service_OnAccept;

# 1987 "obj/release.linux/Service.c"
static struct __ecereNameSpace__ecere__com__Class * __ecereClass___ecereNameSpace__ecere__net__Service;

# 2059 "obj/release.linux/Service.c"
unsigned int __ecereMethod___ecereNameSpace__ecere__net__Service_Process(struct __ecereNameSpace__ecere__com__Instance * this)
{
 struct __ecereNameSpace__ecere__net__Service * __ecerePointer___ecereNameSpace__ecere__net__Service = (struct __ecereNameSpace__ecere__net__Service *)(this ? (((char *)this) + __ecereClass___ecereNameSpace__ecere__net__Service->offset) : 0);
unsigned int gotEvent = 0;

if(__ecerePointer___ecereNameSpace__ecere__net__Service->s != -1)
{
fd_set rs, ws, es;
int selectResult;
struct timeval tvTO =
{
0, 200000
};

do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&rs)).__fds_bits[0]):"memory");

}while(0);
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&ws)).__fds_bits[0]):"memory");

}while(0);
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&es)).__fds_bits[0]):"memory");

}while(0);
((void)((*(&rs)).__fds_bits[(__ecerePointer___ecereNameSpace__ecere__net__Service->s / (8 * (int)sizeof(__fd_mask)))] |= ((__fd_mask)1 << (__ecerePointer___ecereNameSpace__ecere__net__Service->s % (8 * (int)sizeof(__fd_mask))))));
((void)((*(&es)).__fds_bits[(__ecerePointer___ecereNameSpace__ecere__net__Service->s / (8 * (int)sizeof(__fd_mask)))] |= ((__fd_mask)1 << (__ecerePointer___ecereNameSpace__ecere__net__Service->s % (8 * (int)sizeof(__fd_mask))))));
selectResult = select((__ecerePointer___ecereNameSpace__ecere__net__Service->s + 1), &rs, &ws, &es, &tvTO);
if(selectResult > 0)
{
if((((*(&rs)).__fds_bits[(__ecerePointer___ecereNameSpace__ecere__net__Service->s / (8 * (int)sizeof(__fd_mask)))] & ((__fd_mask)1 << (__ecerePointer___ecereNameSpace__ecere__net__Service->s % (8 * (int)sizeof(__fd_mask))))) != 0))
{
__ecerePointer___ecereNameSpace__ecere__net__Service->accepted = 0;
((void (*)(struct __ecereNameSpace__ecere__com__Instance *))__extension__ ({
struct __ecereNameSpace__ecere__com__Instance * __internal_ClassInst = this;

__internal_ClassInst ? __internal_ClassInst->_vTbl : __ecereClass___ecereNameSpace__ecere__net__Service->_vTbl;
})[__ecereVMethodID___ecereNameSpace__ecere__net__Service_OnAccept])(this);
if(!__ecerePointer___ecereNameSpace__ecere__net__Service->accepted)
{
SOCKET s;
SOCKADDR_IN a;
socklen_t addrLen = sizeof (a);

s = accept(__ecerePointer___ecereNameSpace__ecere__net__Service->s, (SOCKADDR *)&a, &addrLen);
close(s);
}
gotEvent |= 1;
}
}
}
return gotEvent;
}

# 1814 "obj/release.linux/network.c"
extern long long __ecereNameSpace__ecere__sys__GetCurrentThreadID(void);

# 1834 "obj/release.linux/network.c"
void __ecereMethod___ecereNameSpace__ecere__sys__OldList_Clear(struct __ecereNameSpace__ecere__sys__OldList * this);

# 1960 "obj/release.linux/network.c"
extern void * __ecereNameSpace__ecere__com__eInstance_New(struct __ecereNameSpace__ecere__com__Class * _class);

# 1966 "obj/release.linux/network.c"
struct __ecereNameSpace__ecere__net__NetworkData
{
struct __ecereNameSpace__ecere__sys__OldList sockets;
struct __ecereNameSpace__ecere__sys__OldList services;
struct __ecereNameSpace__ecere__sys__OldList connectSockets;
fd_set readSet, writeSet, exceptSet;
fd_set selectRS, selectWS, selectES;
int ns;
struct __ecereNameSpace__ecere__com__Instance * networkThread;
struct __ecereNameSpace__ecere__sys__Semaphore * socketsSemaphore;
struct __ecereNameSpace__ecere__sys__Semaphore * selectSemaphore;
unsigned int networkEvent;
unsigned int connectEvent;
unsigned int networkInitialized;
unsigned int networkTerminated;
unsigned int errorLevel, lastErrorCode;
unsigned int leftOverBytes;
struct __ecereNameSpace__ecere__sys__Mutex * processMutex;
struct __ecereNameSpace__ecere__sys__Mutex * mutex;
long long mainThreadID;
struct __ecereNameSpace__ecere__sys__OldList mtSemaphores;
};

# 2041 "obj/release.linux/network.c"
void __ecereMethod___ecereNameSpace__ecere__sys__Thread_Create();

# 2047 "obj/release.linux/network.c"
struct __ecereNameSpace__ecere__net__NetworkData __ecereNameSpace__ecere__net__network;

# 3118 "obj/release.linux/network.c"
static struct __ecereNameSpace__ecere__com__Class * __ecereClass___ecereNameSpace__ecere__net__NetworkThread;

# 3120 "obj/release.linux/network.c"
extern struct __ecereNameSpace__ecere__com__Class * __ecereClass___ecereNameSpace__ecere__sys__Semaphore;

# 3122 "obj/release.linux/network.c"
extern struct __ecereNameSpace__ecere__com__Class * __ecereClass___ecereNameSpace__ecere__sys__Mutex;

# 3124 "obj/release.linux/network.c"
extern struct __ecereNameSpace__ecere__com__Class * __ecereClass___ecereNameSpace__ecere__net__Socket;

# 3157 "obj/release.linux/network.c"
struct __ecereNameSpace__ecere__net__Socket
{
struct __ecereNameSpace__ecere__com__Instance * service;
unsigned int leftOver;
char inetAddress[20];
int inetPort;
struct __ecereNameSpace__ecere__com__Instance * prev;
struct __ecereNameSpace__ecere__com__Instance * next;
int s;
char * address;
struct __ecereNameSpace__ecere__com__Instance * connectThread;
int disconnectCode;
unsigned int destroyed;
int _connected;
unsigned int disconnected;
unsigned char * recvBuffer;
unsigned int recvBytes;
unsigned int recvBufferSize;
int type;
unsigned int processAlone;
struct sockaddr_in a;
struct __ecereNameSpace__ecere__sys__Mutex * mutex;
};

# 3181 "obj/release.linux/network.c"
unsigned int __ecereNameSpace__ecere__net__Network_Initialize()
{
if(!__ecereNameSpace__ecere__net__network.networkInitialized)
{
__ecereNameSpace__ecere__net__network.networkInitialized = 1;
__ecereNameSpace__ecere__net__network.networkTerminated = 0;
__ecereMethod___ecereNameSpace__ecere__sys__OldList_Clear(&__ecereNameSpace__ecere__net__network.services);
__ecereNameSpace__ecere__net__network.services.offset = (unsigned int)(uintptr_t)&((struct __ecereNameSpace__ecere__net__Service *)(((char *)((struct __ecereNameSpace__ecere__com__Instance *)(void *)0) + __ecereClass___ecereNameSpace__ecere__net__Service->offset)))->prev;
__ecereMethod___ecereNameSpace__ecere__sys__OldList_Clear(&__ecereNameSpace__ecere__net__network.sockets);
__ecereNameSpace__ecere__net__network.sockets.offset = (unsigned int)(uintptr_t)&((struct __ecereNameSpace__ecere__net__Socket *)(((char *)((struct __ecereNameSpace__ecere__com__Instance *)(void *)0) + __ecereClass___ecereNameSpace__ecere__net__Socket->offset)))->prev;
__ecereMethod___ecereNameSpace__ecere__sys__OldList_Clear(&__ecereNameSpace__ecere__net__network.connectSockets);
__ecereNameSpace__ecere__net__network.connectSockets.offset = (unsigned int)(uintptr_t)&((struct __ecereNameSpace__ecere__net__Socket *)(((char *)((struct __ecereNameSpace__ecere__com__Instance *)(void *)0) + __ecereClass___ecereNameSpace__ecere__net__Socket->offset)))->prev;
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&__ecereNameSpace__ecere__net__network.readSet)).__fds_bits[0]):"memory");

}while(0);
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&__ecereNameSpace__ecere__net__network.writeSet)).__fds_bits[0]):"memory");

}while(0);
do
{
int __d0, __d1;

__asm__ volatile("cld; rep; stosl":"=c"(__d0),"=D"(__d1):"a"(0),"0"(sizeof(fd_set) / sizeof(__fd_mask)),"1"(&(*(&__ecereNameSpace__ecere__net__network.exceptSet)).__fds_bits[0]):"memory");

}while(0);
__ecereNameSpace__ecere__net__network.socketsSemaphore = __ecereNameSpace__ecere__com__eInstance_New(__ecereClass___ecereNameSpace__ecere__sys__Semaphore);
__ecereNameSpace__ecere__net__network.selectSemaphore = __ecereNameSpace__ecere__com__eInstance_New(__ecereClass___ecereNameSpace__ecere__sys__Semaphore);
__ecereNameSpace__ecere__net__network.networkThread = __ecereNameSpace__ecere__com__eInstance_New(__ecereClass___ecereNameSpace__ecere__net__NetworkThread);
__ecereNameSpace__ecere__net__network.networkThread->_refCount++;
__ecereNameSpace__ecere__net__network.errorLevel = 2;
__ecereNameSpace__ecere__net__network.processMutex = __ecereNameSpace__ecere__com__eInstance_New(__ecereClass___ecereNameSpace__ecere__sys__Mutex);
__ecereNameSpace__ecere__net__network.mutex = __ecereNameSpace__ecere__com__eInstance_New(__ecereClass___ecereNameSpace__ecere__sys__Mutex);
__ecereNameSpace__ecere__net__network.mainThreadID = __ecereNameSpace__ecere__sys__GetCurrentThreadID();
__ecereMethod___ecereNameSpace__ecere__sys__Thread_Create(__ecereNameSpace__ecere__net__network.networkThread);
}
return 1;
}

