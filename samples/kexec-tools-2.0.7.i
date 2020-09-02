# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 9 "kexec/kexec-elf.h"
struct mem_ehdr {
 unsigned ei_class;
 unsigned ei_data;
 unsigned e_type;
 unsigned e_machine;
 unsigned e_version;
 unsigned e_flags;
 unsigned e_phnum;
 unsigned e_shnum;
 unsigned e_shstrndx;
 unsigned long long e_entry;
 unsigned long long e_phoff;
 unsigned long long e_shoff;
 unsigned e_notenum;
 struct mem_phdr *e_phdr;
 struct mem_shdr *e_shdr;
 struct mem_note *e_note;
 unsigned long rel_addr, rel_size;
};

# 29 "kexec/kexec-elf.h"
struct mem_phdr {
 unsigned long long p_paddr;
 unsigned long long p_vaddr;
 unsigned long long p_filesz;
 unsigned long long p_memsz;
 unsigned long long p_offset;
 const char *p_data;
 unsigned p_type;
 unsigned p_flags;
 unsigned long long p_align;
};

# 41 "kexec/kexec-elf.h"
struct mem_shdr {
 unsigned sh_name;
 unsigned sh_type;
 unsigned long long sh_flags;
 unsigned long long sh_addr;
 unsigned long long sh_offset;
 unsigned long long sh_size;
 unsigned sh_link;
 unsigned sh_info;
 unsigned long long sh_addralign;
 unsigned long long sh_entsize;
 const unsigned char *sh_data;
};

# 71 "kexec/kexec-elf.h"
struct mem_note {
 unsigned n_type;
 unsigned n_descsz;
 const char *n_name;
 const void *n_desc;
};

# 15 "kexec/kexec-elf.c"
uint16_t elf16_to_cpu(const struct mem_ehdr *ehdr, uint16_t value)
{
 if (ehdr->ei_data == 1 /* 2's complement, little endian */) {
  value = (value);
 }
 else if (ehdr->ei_data == 2 /* 2's complement, big endian */) {
  value = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 }
 return value;
}

# 48 "kexec/kexec-elf.c"
uint16_t cpu_to_elf16(const struct mem_ehdr *ehdr, uint16_t value)
{
 if (ehdr->ei_data == 1 /* 2's complement, little endian */) {
  value = (value);
 }
 else if (ehdr->ei_data == 2 /* 2's complement, big endian */) {
  value = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (value); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 }
 return value;
}

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 37 "./include/elf.h"
typedef uint16_t Elf64_Half;

# 42 "./include/elf.h"
typedef uint32_t Elf64_Word;

# 53 "./include/elf.h"
typedef uint64_t Elf64_Addr;

# 57 "./include/elf.h"
typedef uint64_t Elf64_Off;

# 93 "./include/elf.h"
typedef struct
{
  unsigned char e_ident[(16)]; /* Magic number and other info */
  Elf64_Half e_type; /* Object file type */
  Elf64_Half e_machine; /* Architecture */
  Elf64_Word e_version; /* Object file version */
  Elf64_Addr e_entry; /* Entry point virtual address */
  Elf64_Off e_phoff; /* Program header table file offset */
  Elf64_Off e_shoff; /* Section header table file offset */
  Elf64_Word e_flags; /* Processor-specific flags */
  Elf64_Half e_ehsize; /* ELF header size in bytes */
  Elf64_Half e_phentsize; /* Program header table entry size */
  Elf64_Half e_phnum; /* Program header table entry count */
  Elf64_Half e_shentsize; /* Section header table entry size */
  Elf64_Half e_shnum; /* Section header table entry count */
  Elf64_Half e_shstrndx; /* Section header string table index */
} Elf64_Ehdr;

# 25 "vmcore-dmesg/vmcore-dmesg.c"
static Elf64_Ehdr ehdr;

# 54 "vmcore-dmesg/vmcore-dmesg.c"
static uint16_t file16_to_cpu(uint16_t val)
{
 if (ehdr.e_ident[5 /* Data encoding byte index */] != 1 /* 2's complement, little endian */)
  val = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (val); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 return val;
}

