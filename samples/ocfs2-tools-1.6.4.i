unsigned int __builtin_bswap32 (unsigned int);
unsigned long long __builtin_bswap64 (unsigned long long);

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 23 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned short __u16;

# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;

# 6 "../include/ocfs2-kernel/sparse_endian_types.h"
typedef __u16 __le16;

# 8 "../include/ocfs2-kernel/sparse_endian_types.h"
typedef __u32 __le32;

# 7 "../include/ocfs2-kernel/quota_tree.h"
struct qt_disk_dqdbheader {
 __le32 dqdh_next_free; /* Number of next block with free entry */
 __le32 dqdh_prev_free; /* Number of previous block with free entry */
 __le16 dqdh_entries; /* Number of valid entries in block */
 __le16 dqdh_pad1;
 __le32 dqdh_pad2;
};

# 82 "quota.c"
void ocfs2_swap_quota_leaf_block_header(struct qt_disk_dqdbheader *bheader)
{
 if (1)
  return;
 bheader->dqdh_next_free = __bswap_32 (bheader->dqdh_next_free);
 bheader->dqdh_prev_free = __bswap_32 (bheader->dqdh_prev_free);
 bheader->dqdh_entries = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (bheader->dqdh_entries); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 47 "/usr/include/i386-linux-gnu/bits/types.h"
typedef unsigned long long int __uint64_t;

# 108 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline __uint64_t
__bswap_64 (__uint64_t __bsx)
{
  return __builtin_bswap64 (__bsx);
}

# 20 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned char __u8;

# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;

# 10 "../include/ocfs2-kernel/sparse_endian_types.h"
typedef __u64 __le64;

# 416 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_block_check {
/*00*/ __le32 bc_crc32e; /* 802.3 Ethernet II CRC32 */
 __le16 bc_ecc; /* Single-error-correction parity vector.
				   This is a simple Hamming code dependant
				   on the blocksize.  OCFS2's maximum
				   blocksize, 4K, requires 16 parity bits,
				   so we fit in __le16. */
 __le16 bc_reserved1;
/*08*/
};

# 434 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_extent_rec {
/*00*/ __le32 e_cpos; /* Offset into the file, in clusters */
 union {
  __le32 e_int_clusters; /* Clusters covered by all children */
  struct {
   __le16 e_leaf_clusters; /* Clusters covered by this
						   extent */
   __u8 e_reserved1;
   __u8 e_flags; /* Extent flags */
  };
 };
 __le64 e_blkno; /* Physical disk offset, in blocks */
/*10*/
};

# 466 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_extent_list {
/*00*/ __le16 l_tree_depth; /* Extent tree depth from this
					   point.  0 means data extents
					   hang directly off this
					   header (a leaf)
					   NOTE: The high 8 bits cannot be
					   used - tree_depth is never that big.
					*/
 __le16 l_count; /* Number of extent records */
 __le16 l_next_free_rec; /* Next unused extent slot */
 __le16 l_reserved1;
 __le64 l_reserved2; /* Pad to
					   sizeof(ocfs2_extent_rec) */
/*10*/ struct ocfs2_extent_rec l_recs[0]; /* Extent records */
};

# 980 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_xattr_entry {
 __le32 xe_name_hash; /* hash value of xattr prefix+suffix. */
 __le16 xe_name_offset; /* byte offset from the 1st entry in the
				    local xattr storage(inode, xattr block or
				    xattr bucket). */
 __u8 xe_name_len; /* xattr name len, does't include prefix. */
 __u8 xe_type; /* the low 7 bits indicate the name prefix
				  * type and the highest bit indicates whether
				  * the EA is stored in the local storage. */
 __le64 xe_value_size; /* real xattr value length. */
};

# 998 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_xattr_header {
 __le16 xh_count; /* contains the count of how
						   many records are in the
						   local xattr storage. */
 __le16 xh_free_start; /* current offset for storing
						   xattr. */
 __le16 xh_name_value_len; /* total length of name/value
						   length in this bucket. */
 __le16 xh_num_buckets; /* Number of xattr buckets
						   in this extent record,
						   only valid in the first
						   bucket. */
 struct ocfs2_block_check xh_check; /* Error checking
						   (Note, this is only
						    used for xattr
						    buckets.  A block uses
						    xb_check and sets
						    this field to zero.) */
 struct ocfs2_xattr_entry xh_entries[0]; /* xattr entry list. */
};

# 1038 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_xattr_tree_root {
/*00*/ __le32 xt_clusters; /* clusters covered by xattr. */
 __le32 xt_reserved0;
 __le64 xt_last_eb_blk; /* Pointer to last extent block */
/*10*/ struct ocfs2_extent_list xt_list; /* Extent record list */
};

# 1059 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_xattr_block {
/*00*/ __u8 xb_signature[8]; /* Signature for verification */
 __le16 xb_suballoc_slot; /* Slot suballocator this
					block belongs to. */
 __le16 xb_suballoc_bit; /* Bit offset in suballocator
					block group */
 __le32 xb_fs_generation; /* Must match super block */
/*10*/ __le64 xb_blkno; /* Offset on disk, in blocks */
 struct ocfs2_block_check xb_check; /* Error checking */
/*20*/ __le16 xb_flags; /* Indicates whether this block contains
					real xattr or a xattr tree. */
 __le16 xb_reserved0;
 __le32 xb_reserved1;
 __le64 xb_suballoc_loc; /* Suballocator block group this
					   xattr block belongs to. Only
					   valid if allocated from a
					   discontiguous block group */
/*30*/ union {
  struct ocfs2_xattr_header xb_header; /* xattr header if this
							block contains xattr */
  struct ocfs2_xattr_tree_root xb_root;/* xattr tree root if this
							block cotains xattr
							tree. */
 } xb_attrs;
};

# 70 "xattr.c"
static void ocfs2_swap_xattr_entry(struct ocfs2_xattr_entry *xe)
{
 xe->xe_name_hash = __bswap_32 (xe->xe_name_hash);
 xe->xe_name_offset = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xe->xe_name_offset); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 xe->xe_value_size = __bswap_64 (xe->xe_value_size);
}

# 89 "xattr.c"
static void ocfs2_swap_xattr_block_header(struct ocfs2_xattr_block *xb)
{
 xb->xb_suballoc_slot = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xb->xb_suballoc_slot); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 xb->xb_suballoc_bit = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xb->xb_suballoc_bit); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 xb->xb_fs_generation = __bswap_32 (xb->xb_fs_generation);
 xb->xb_blkno = __bswap_64 (xb->xb_blkno);
 xb->xb_flags = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xb->xb_flags); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 xb->xb_suballoc_loc = __bswap_64 (xb->xb_suballoc_loc);
}

# 99 "xattr.c"
static void ocfs2_swap_xattr_header(struct ocfs2_xattr_header *xh)
{
 if (1)
  return;

 xh->xh_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xh->xh_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 xh->xh_free_start = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xh->xh_free_start); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 xh->xh_name_value_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xh->xh_name_value_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 xh->xh_num_buckets = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (xh->xh_num_buckets); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 449 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_chain_rec {
 __le32 c_free; /* Number of free bits in this chain. */
 __le32 c_total; /* Number of total bits in this chain */
 __le64 c_blkno; /* Physical disk offset (blocks) of 1st group */
};

# 455 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_truncate_rec {
 __le32 t_start; /* 1st cluster in this log */
 __le32 t_clusters; /* Number of total clusters covered */
};

# 487 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_chain_list {
/*00*/ __le16 cl_cpg; /* Clusters per Block Group */
 __le16 cl_bpc; /* Bits per cluster */
 __le16 cl_count; /* Total chains in this list */
 __le16 cl_next_free_rec; /* Next unused chain slot */
 __le64 cl_reserved1;
/*10*/ struct ocfs2_chain_rec cl_recs[0]; /* Chain records */
};

# 501 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_truncate_log {
/*00*/ __le16 tl_count; /* Total records in this log */
 __le16 tl_used; /* Number of records in use */
 __le32 tl_reserved1;
/*08*/ struct ocfs2_truncate_rec tl_recs[0]; /* Truncate records */
};

# 566 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_cluster_info {
/*00*/ __u8 ci_stack[4];
 __le32 ci_reserved;
/*08*/ __u8 ci_cluster[16];
/*18*/
};

# 578 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_super_block {
/*00*/ __le16 s_major_rev_level;
 __le16 s_minor_rev_level;
 __le16 s_mnt_count;
 __le16 s_max_mnt_count;
 __le16 s_state; /* File system state */
 __le16 s_errors; /* Behaviour when detecting errors */
 __le32 s_checkinterval; /* Max time between checks */
/*10*/ __le64 s_lastcheck; /* Time of last check */
 __le32 s_creator_os; /* OS */
 __le32 s_feature_compat; /* Compatible feature set */
/*20*/ __le32 s_feature_incompat; /* Incompatible feature set */
 __le32 s_feature_ro_compat; /* Readonly-compatible feature set */
 __le64 s_root_blkno; /* Offset, in blocks, of root directory
					   dinode */
/*30*/ __le64 s_system_dir_blkno; /* Offset, in blocks, of system
					   directory dinode */
 __le32 s_blocksize_bits; /* Blocksize for this fs */
 __le32 s_clustersize_bits; /* Clustersize for this fs */
/*40*/ __le16 s_max_slots; /* Max number of simultaneous mounts
					   before tunefs required */
 __le16 s_tunefs_flag;
 __le32 s_uuid_hash; /* hash value of uuid */
 __le64 s_first_cluster_group; /* Block offset of 1st cluster
					 * group header */
/*50*/ __u8 s_label[64]; /* Label for mounting, etc. */
/*90*/ __u8 s_uuid[16]; /* 128-bit uuid */
/*A0*/ struct ocfs2_cluster_info s_cluster_info; /* Selected userspace
						     stack.  Only valid
						     with INCOMPAT flag. */
/*B8*/ __le16 s_xattr_inline_size; /* extended attribute inline size
					   for this fs*/
 __le16 s_reserved0;
 __le32 s_dx_seed[3]; /* seed[0-2] for dx dir hash.
					 * s_uuid_hash serves as seed[3]. */
/*C0*/ __le64 s_reserved2[15]; /* Fill out superblock */
/*140*/

 /*
	 * NOTE: As stated above, all offsets are relative to
	 * ocfs2_dinode.id2, which is at 0xC0 in the inode.
	 * 0xC0 + 0x140 = 0x200 or 512 bytes.  A superblock must fit within
	 * our smallest blocksize, which is 512 bytes.  To ensure this,
	 * we reserve the space in s_reserved2.  Anything past s_reserved2
	 * will not be available on the smallest blocksize.
	 */
};

# 631 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_local_alloc
{
/*00*/ __le32 la_bm_off; /* Starting bit offset in main bitmap */
 __le16 la_size; /* Size of included bitmap, in bytes */
 __le16 la_reserved1;
 __le64 la_reserved2;
/*10*/ __u8 la_bitmap[0];
};

# 644 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_inline_data
{
/*00*/ __le16 id_count; /* Number of bytes that can be used
				 * for data, starting at id_data */
 __le16 id_reserved0;
 __le32 id_reserved1;
 __u8 id_data[0]; /* Start of user data */
};

# 656 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_dinode {
/*00*/ __u8 i_signature[8]; /* Signature for validation */
 __le32 i_generation; /* Generation number */
 __le16 i_suballoc_slot; /* Slot suballocator this inode
					   belongs to */
 __le16 i_suballoc_bit; /* Bit offset in suballocator
					   block group */
/*10*/ __le16 i_links_count_hi; /* High 16 bits of links count */
 __le16 i_xattr_inline_size;
 __le32 i_clusters; /* Cluster count */
 __le32 i_uid; /* Owner UID */
 __le32 i_gid; /* Owning GID */
/*20*/ __le64 i_size; /* Size in bytes */
 __le16 i_mode; /* File mode */
 __le16 i_links_count; /* Links count */
 __le32 i_flags; /* File flags */
/*30*/ __le64 i_atime; /* Access time */
 __le64 i_ctime; /* Creation time */
/*40*/ __le64 i_mtime; /* Modification time */
 __le64 i_dtime; /* Deletion time */
/*50*/ __le64 i_blkno; /* Offset on disk, in blocks */
 __le64 i_last_eb_blk; /* Pointer to last extent
					   block */
/*60*/ __le32 i_fs_generation; /* Generation per fs-instance */
 __le32 i_atime_nsec;
 __le32 i_ctime_nsec;
 __le32 i_mtime_nsec;
/*70*/ __le32 i_attr;
 __le16 i_orphaned_slot; /* Only valid when OCFS2_ORPHANED_FL
					   was set in i_flags */
 __le16 i_dyn_features;
 __le64 i_xattr_loc;
/*80*/ struct ocfs2_block_check i_check; /* Error checking */
 __le64 i_dx_root;
/*90*/ __le64 i_refcount_loc;
 __le64 i_suballoc_loc; /* Suballocator block group this
					   inode belongs to.  Only valid
					   if allocated from a
					   discontiguous block group */
/*A0*/ __le64 i_reserved2[3];
/*B8*/ union {
  __le64 i_pad1; /* Generic way to refer to this
					   64bit union */
  struct {
   __le64 i_rdev; /* Device number */
  } dev1;
  struct { /* Info for bitmap system
					   inodes */
   __le32 i_used; /* Bits (ie, clusters) used  */
   __le32 i_total; /* Total bits (clusters)
					   available */
  } bitmap1;
  struct { /* Info for journal system
					   inodes */
   __le32 ij_flags; /* Mounted, version, etc. */
   __le32 ij_recovery_generation; /* Incremented when the
							  journal is recovered
							  after an unclean
							  shutdown */
  } journal1;
 } id1; /* Inode type dependant 1 */
/*C0*/ union {
  struct ocfs2_super_block i_super;
  struct ocfs2_local_alloc i_lab;
  struct ocfs2_chain_list i_chain;
  struct ocfs2_extent_list i_list;
  struct ocfs2_truncate_log i_dealloc;
  struct ocfs2_inline_data i_data;
  __u8 i_symlink[0];
 } id2;
/* Actual on-disk size is one block */
};

# 734 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_dir_entry {
/*00*/ __le64 inode; /* Inode number */
 __le16 rec_len; /* Directory entry length */
 __u8 name_len; /* Name length */
 __u8 file_type;
/*0C*/ char name[255]; /* File name */
/* Actual on-disk length specified by rec_len */
};

# 751 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_dir_block_trailer {
/*00*/ __le64 db_compat_inode; /* Always zero. Was inode */

 __le16 db_compat_rec_len; /* Backwards compatible with
						 * ocfs2_dir_entry. */
 __u8 db_compat_name_len; /* Always zero. Was name_len */
 __u8 db_reserved0;
 __le16 db_reserved1;
 __le16 db_free_rec_len; /* Size of largest empty hole
						 * in this block. (unused) */
/*10*/ __u8 db_signature[8]; /* Signature for verification */
 __le64 db_reserved2;
 __le64 db_free_next; /* Next block in list (unused) */
/*20*/ __le64 db_blkno; /* Offset on disk, in blocks */
 __le64 db_parent_dinode; /* dinode which owns me, in
						   blocks */
/*30*/ struct ocfs2_block_check db_check; /* Error checking */
/*40*/
};

# 778 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_dx_entry {
 __le32 dx_major_hash; /* Used to find logical
					 * cluster in index */
 __le32 dx_minor_hash; /* Lower bits used to find
					 * block in cluster */
 __le64 dx_dirent_blk; /* Physical block in unindexed
					 * tree holding this dirent. */
};

# 787 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_dx_entry_list {
 __le32 de_reserved;
 __le16 de_count; /* Maximum number of entries
					 * possible in de_entries */
 __le16 de_num_used; /* Current number of
					 * de_entries entries */
 struct ocfs2_dx_entry de_entries[0]; /* Indexed dir entries
							 * in a packed array of
							 * length de_num_used */
};

# 807 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_dx_root_block {
 __u8 dr_signature[8]; /* Signature for verification */
 struct ocfs2_block_check dr_check; /* Error checking */
 __le16 dr_suballoc_slot; /* Slot suballocator this
						 * block belongs to. */
 __le16 dr_suballoc_bit; /* Bit offset in suballocator
						 * block group */
 __le32 dr_fs_generation; /* Must match super block */
 __le64 dr_blkno; /* Offset on disk, in blocks */
 __le64 dr_last_eb_blk; /* Pointer to last
						 * extent block */
 __le32 dr_clusters; /* Clusters allocated
						 * to the indexed tree. */
 __u8 dr_flags; /* OCFS2_DX_FLAG_* flags */
 __u8 dr_reserved0;
 __le16 dr_reserved1;
 __le64 dr_dir_blkno; /* Pointer to parent inode */
 __le32 dr_num_entries; /* Total number of
						 * names stored in
						 * this directory.*/
 __le32 dr_reserved2;
 __le64 dr_free_blk; /* Pointer to head of free
						 * unindexed block list. */
 __le64 dr_suballoc_loc; /* Suballocator block group
						 * this root belongs to.
						 * Only valid if allocated
						 * from a discontiguous
						 * block group. */
 __le64 dr_reserved3[14];
 union {
  struct ocfs2_extent_list dr_list; /* Keep this aligned to 128
						   * bits for maximum space
						   * efficiency. */
  struct ocfs2_dx_entry_list dr_entries; /* In-root-block list of
							* entries. We grow out
							* to extents if this
							* gets too big. */
 };
};

# 1142 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_global_disk_dqinfo {
/*00*/ __le32 dqi_bgrace; /* Grace time for space softlimit excess */
 __le32 dqi_igrace; /* Grace time for inode softlimit excess */
 __le32 dqi_syncms; /* Time after which we sync local changes to
				 * global quota file */
 __le32 dqi_blocks; /* Number of blocks in quota file */
/*10*/ __le32 dqi_free_blk; /* First free block in quota file */
 __le32 dqi_free_entry; /* First block with free dquot entry in quota
				 * file */
};

# 52 "../include/o2dlm/o2dlm.h"
struct o2dlm_ctxt;

# 141 "../include/ocfs2/ocfs2.h"
typedef struct _ocfs2_filesys ocfs2_filesys;

# 142 "../include/ocfs2/ocfs2.h"
typedef struct _ocfs2_cached_inode ocfs2_cached_inode;

# 144 "../include/ocfs2/ocfs2.h"
typedef struct _io_channel io_channel;

# 147 "../include/ocfs2/ocfs2.h"
typedef struct _ocfs2_bitmap ocfs2_bitmap;

# 158 "../include/ocfs2/ocfs2.h"
struct _ocfs2_quota_info {
 ocfs2_cached_inode *qi_inode;
 int flags;
 struct ocfs2_global_disk_dqinfo qi_info;
};

# 164 "../include/ocfs2/ocfs2.h"
typedef struct _ocfs2_quota_info ocfs2_quota_info;

# 166 "../include/ocfs2/ocfs2.h"
struct _ocfs2_filesys {
 char *fs_devname;
 uint32_t fs_flags;
 io_channel *fs_io;
 struct ocfs2_dinode *fs_super;
 struct ocfs2_dinode *fs_orig_super;
 unsigned int fs_blocksize;
 unsigned int fs_clustersize;
 uint32_t fs_clusters;
 uint64_t fs_blocks;
 uint32_t fs_umask;
 uint64_t fs_root_blkno;
 uint64_t fs_sysdir_blkno;
 uint64_t fs_first_cg_blkno;
 char uuid_str[16 * 2 + 1];

 /* Allocators */
 ocfs2_cached_inode *fs_cluster_alloc;
 ocfs2_cached_inode **fs_inode_allocs;
 ocfs2_cached_inode *fs_system_inode_alloc;
 ocfs2_cached_inode **fs_eb_allocs;
 ocfs2_cached_inode *fs_system_eb_alloc;

 struct o2dlm_ctxt *fs_dlm_ctxt;
 struct ocfs2_image_state *ost;

 ocfs2_quota_info qinfo[2];

 /* Reserved for the use of the calling application. */
 void *fs_private;
};

# 198 "../include/ocfs2/ocfs2.h"
struct _ocfs2_cached_inode {
 struct _ocfs2_filesys *ci_fs;
 uint64_t ci_blkno;
 struct ocfs2_dinode *ci_inode;
 ocfs2_bitmap *ci_chains;
};

# 373 "../include/ocfs2/ocfs2.h"
void ocfs2_swap_extent_list_from_cpu(ocfs2_filesys *fs, void *obj,
         struct ocfs2_extent_list *el);

# 375 "../include/ocfs2/ocfs2.h"
void ocfs2_swap_extent_list_to_cpu(ocfs2_filesys *fs, void *obj,
       struct ocfs2_extent_list *el);

# 104 "dirblock.c"
static void ocfs2_swap_dir_entry(struct ocfs2_dir_entry *dirent)
{
 if (1)
  return;

 dirent->inode = __bswap_64 (dirent->inode);
 dirent->rec_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dirent->rec_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 155 "dirblock.c"
void ocfs2_swap_dir_trailer(struct ocfs2_dir_block_trailer *trailer)
{
 if (1)
  return;

 trailer->db_compat_inode = __bswap_64 (trailer->db_compat_inode);
 trailer->db_compat_rec_len = __bswap_64 (trailer->db_compat_rec_len);
 trailer->db_blkno = __bswap_64 (trailer->db_blkno);
 trailer->db_parent_dinode = __bswap_64 (trailer->db_parent_dinode);
 trailer->db_free_rec_len = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (trailer->db_free_rec_len); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 trailer->db_free_next = __bswap_64 (trailer->db_free_next);
}

# 241 "dirblock.c"
static void ocfs2_swap_dx_entry(struct ocfs2_dx_entry *dx_entry)
{
 dx_entry->dx_major_hash = __bswap_32 (dx_entry->dx_major_hash);
 dx_entry->dx_minor_hash = __bswap_32 (dx_entry->dx_minor_hash);
 dx_entry->dx_dirent_blk = __bswap_64 (dx_entry->dx_dirent_blk);
}

# 248 "dirblock.c"
static void ocfs2_swap_dx_entry_list_to_cpu(struct ocfs2_dx_entry_list *dl_list)
{
 int i;

 if (1)
  return;

 dl_list->de_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dl_list->de_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 dl_list->de_num_used = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dl_list->de_num_used); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

 for (i = 0; i < dl_list->de_count; i++)
  ocfs2_swap_dx_entry(&dl_list->de_entries[i]);
}

# 262 "dirblock.c"
static void ocfs2_swap_dx_entry_list_from_cpu(struct ocfs2_dx_entry_list *dl_list)
{
 int i;

 if (1)
  return;

 for (i = 0; i < dl_list->de_count; i++)
  ocfs2_swap_dx_entry(&dl_list->de_entries[i]);

 dl_list->de_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dl_list->de_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 dl_list->de_num_used = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dl_list->de_num_used); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 276 "dirblock.c"
static void ocfs2_swap_dx_root_to_cpu(ocfs2_filesys *fs,
    struct ocfs2_dx_root_block *dx_root)
{
 if (1)
  return;

 dx_root->dr_suballoc_slot = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dx_root->dr_suballoc_slot); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 dx_root->dr_suballoc_bit = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dx_root->dr_suballoc_bit); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 dx_root->dr_fs_generation = __bswap_32 (dx_root->dr_fs_generation);
 dx_root->dr_blkno = __bswap_64 (dx_root->dr_blkno);
 dx_root->dr_last_eb_blk = __bswap_64 (dx_root->dr_last_eb_blk);
 dx_root->dr_clusters = __bswap_32 (dx_root->dr_clusters);
 dx_root->dr_dir_blkno = __bswap_64 (dx_root->dr_dir_blkno);
 dx_root->dr_num_entries = __bswap_32 (dx_root->dr_num_entries);
 dx_root->dr_free_blk = __bswap_64 (dx_root->dr_free_blk);

 if (dx_root->dr_flags & 0x01)
  ocfs2_swap_dx_entry_list_to_cpu(&dx_root->dr_entries);
 else
  ocfs2_swap_extent_list_to_cpu(fs, dx_root, &dx_root->dr_list);
}

# 298 "dirblock.c"
static void ocfs2_swap_dx_root_from_cpu(ocfs2_filesys *fs,
    struct ocfs2_dx_root_block *dx_root)
{
 if (1)
  return;

 dx_root->dr_suballoc_slot = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dx_root->dr_suballoc_slot); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 dx_root->dr_suballoc_bit = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dx_root->dr_suballoc_bit); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 dx_root->dr_fs_generation = __bswap_32 (dx_root->dr_fs_generation);
 dx_root->dr_blkno = __bswap_64 (dx_root->dr_blkno);
 dx_root->dr_last_eb_blk = __bswap_64 (dx_root->dr_last_eb_blk);
 dx_root->dr_clusters = __bswap_32 (dx_root->dr_clusters);
 dx_root->dr_dir_blkno = __bswap_64 (dx_root->dr_dir_blkno);
 dx_root->dr_num_entries = __bswap_32 (dx_root->dr_num_entries);
 dx_root->dr_free_blk = __bswap_64 (dx_root->dr_free_blk);

 if (dx_root->dr_flags & 0x01)
  ocfs2_swap_dx_entry_list_from_cpu(&dx_root->dr_entries);
 else
  ocfs2_swap_extent_list_from_cpu(fs, dx_root, &dx_root->dr_list);
}

# 870 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_group_desc
{
/*00*/ __u8 bg_signature[8]; /* Signature for validation */
 __le16 bg_size; /* Size of included bitmap in
					   bytes. */
 __le16 bg_bits; /* Bits represented by this
					   group. */
 __le16 bg_free_bits_count; /* Free bits count */
 __le16 bg_chain; /* What chain I am in. */
/*10*/ __le32 bg_generation;
 __le32 bg_reserved1;
 __le64 bg_next_group; /* Next group in my list, in
					   blocks */
/*20*/ __le64 bg_parent_dinode; /* dinode which owns me, in
					   blocks */
 __le64 bg_blkno; /* Offset on disk, in blocks */
/*30*/ struct ocfs2_block_check bg_check; /* Error checking */
 __le64 bg_reserved2;
/*40*/ union {
  __u8 bg_bitmap[0];
  struct {
   /*
			 * Block groups may be discontiguous when
			 * OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG is set.
			 * The extents of a discontigous block group are
			 * stored in bg_list.  It is a flat list.
			 * l_tree_depth must always be zero.  A
			 * discontiguous group is signified by a non-zero
			 * bg_list->l_next_free_rec.  Only block groups
			 * can be discontiguous; Cluster groups cannot.
			 * We've never made a block group with more than
			 * 2048 blocks (256 bytes of bg_bitmap).  This
			 * codifies that limit so that we can fit bg_list.
			 * bg_size of a discontiguous block group will
			 * be 256 to match bg_bitmap_filler.
			 */
   __u8 bg_bitmap_filler[256];
/*140*/ struct ocfs2_extent_list bg_list;
  };
 };
/* Actual on-disk size is one block */
};

# 34 "chain.c"
static void ocfs2_swap_group_desc_header(struct ocfs2_group_desc *gd)
{
 gd->bg_size = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (gd->bg_size); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 gd->bg_bits = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (gd->bg_bits); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 gd->bg_free_bits_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (gd->bg_free_bits_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 gd->bg_chain = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (gd->bg_chain); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 gd->bg_generation = __bswap_32 (gd->bg_generation);
 gd->bg_next_group = __bswap_64 (gd->bg_next_group);
 gd->bg_parent_dinode = __bswap_64 (gd->bg_parent_dinode);
 gd->bg_blkno = __bswap_64 (gd->bg_blkno);
}

# 103 "inode.c"
static void ocfs2_swap_inode_second(struct ocfs2_dinode *di)
{
 if (((((di->i_mode)) & 0170000 /* These bits determine file type.  */) == (0020000 /* Character device.  */)) || ((((di->i_mode)) & 0170000 /* These bits determine file type.  */) == (0060000 /* Block device.  */)))
  di->id1.dev1.i_rdev = __bswap_64 (di->id1.dev1.i_rdev);
 else if (di->i_flags & (0x00000080) /* Allocation bitmap */) {
  di->id1.bitmap1.i_used = __bswap_32 (di->id1.bitmap1.i_used);
  di->id1.bitmap1.i_total = __bswap_32 (di->id1.bitmap1.i_total);
 } else if (di->i_flags & (0x00000100) /* Slot local journal */) {
  di->id1.journal1.ij_flags = __bswap_32 (di->id1.journal1.ij_flags);
  di->id1.journal1.ij_recovery_generation =
   __bswap_32 (di->id1.journal1.ij_recovery_generation);
 }

 /* we need to be careful to swap the union member that is in use.
	 * first the ones that are explicitly marked with flags.. */
 if (di->i_flags & (0x00000020) /* Super block */) {
  struct ocfs2_super_block *sb = &di->id2.i_super;

  sb->s_major_rev_level = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_major_rev_level); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_minor_rev_level = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_minor_rev_level); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_mnt_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_mnt_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_max_mnt_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_max_mnt_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_state = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_state); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_errors = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_errors); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_checkinterval = __bswap_32 (sb->s_checkinterval);
  sb->s_lastcheck = __bswap_64 (sb->s_lastcheck);
  sb->s_creator_os = __bswap_32 (sb->s_creator_os);
  sb->s_feature_compat = __bswap_32 (sb->s_feature_compat);
  sb->s_feature_ro_compat = __bswap_32 (sb->s_feature_ro_compat);
  sb->s_feature_incompat = __bswap_32 (sb->s_feature_incompat);
  sb->s_root_blkno = __bswap_64 (sb->s_root_blkno);
  sb->s_system_dir_blkno = __bswap_64 (sb->s_system_dir_blkno);
  sb->s_blocksize_bits = __bswap_32 (sb->s_blocksize_bits);
  sb->s_clustersize_bits = __bswap_32 (sb->s_clustersize_bits);
  sb->s_max_slots = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_max_slots); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_tunefs_flag = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_tunefs_flag); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_uuid_hash = __bswap_32 (sb->s_uuid_hash);
  sb->s_first_cluster_group = __bswap_64 (sb->s_first_cluster_group);
  sb->s_xattr_inline_size = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sb->s_xattr_inline_size); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  sb->s_dx_seed[0] = __bswap_32 (sb->s_dx_seed[0]);
  sb->s_dx_seed[1] = __bswap_32 (sb->s_dx_seed[1]);
  sb->s_dx_seed[2] = __bswap_32 (sb->s_dx_seed[2]);

 } else if (di->i_flags & (0x00000040) /* Slot local alloc bitmap */) {
  struct ocfs2_local_alloc *la = &di->id2.i_lab;

  la->la_bm_off = __bswap_32 (la->la_bm_off);
  la->la_size = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (la->la_size); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

 } else if (di->i_flags & (0x00000400) /* Chain allocator */) {
  struct ocfs2_chain_list *cl = &di->id2.i_chain;

  cl->cl_cpg = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cl->cl_cpg); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  cl->cl_bpc = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cl->cl_bpc); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  cl->cl_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cl->cl_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  cl->cl_next_free_rec = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (cl->cl_next_free_rec); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

 } else if (di->i_flags & (0x00000800) /* Truncate log */) {
  struct ocfs2_truncate_log *tl = &di->id2.i_dealloc;

  tl->tl_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (tl->tl_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  tl->tl_used = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (tl->tl_used); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 } else if (di->i_dyn_features & (0x0001) /* Data stored in inode block */) {
  struct ocfs2_inline_data *id = &di->id2.i_data;

  id->id_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (id->id_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 } else if (di->i_dyn_features & (0x0008)) {
  di->i_dx_root = __bswap_64 (di->i_dx_root);
 }
}

# 174 "inode.c"
static void ocfs2_swap_inode_first(struct ocfs2_dinode *di)
{
 di->i_generation = __bswap_32 (di->i_generation);
 di->i_suballoc_slot = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (di->i_suballoc_slot); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 di->i_suballoc_bit = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (di->i_suballoc_bit); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 di->i_xattr_inline_size = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (di->i_xattr_inline_size); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 di->i_clusters = __bswap_32 (di->i_clusters);
 di->i_uid = __bswap_32 (di->i_uid);
 di->i_gid = __bswap_32 (di->i_gid);
 di->i_size = __bswap_64 (di->i_size);
 di->i_mode = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (di->i_mode); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 di->i_links_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (di->i_links_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 di->i_flags = __bswap_32 (di->i_flags);
 di->i_atime = __bswap_64 (di->i_atime);
 di->i_ctime = __bswap_64 (di->i_ctime);
 di->i_mtime = __bswap_64 (di->i_mtime);
 di->i_dtime = __bswap_64 (di->i_dtime);
 di->i_blkno = __bswap_64 (di->i_blkno);
 di->i_last_eb_blk = __bswap_64 (di->i_last_eb_blk);
 di->i_fs_generation = __bswap_32 (di->i_fs_generation);
 di->i_atime_nsec = __bswap_32 (di->i_atime_nsec);
 di->i_ctime_nsec = __bswap_32 (di->i_ctime_nsec);
 di->i_mtime_nsec = __bswap_32 (di->i_mtime_nsec);
 di->i_attr = __bswap_32 (di->i_attr);
 di->i_orphaned_slot = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (di->i_orphaned_slot); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 di->i_dyn_features = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (di->i_dyn_features); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 di->i_xattr_loc = __bswap_64 (di->i_xattr_loc);
 di->i_refcount_loc = __bswap_64 (di->i_refcount_loc);
 di->i_suballoc_loc = __bswap_64 (di->i_suballoc_loc);
}

# 537 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_slot_map {
/*00*/ __le16 sm_slots[0];
/*
 * Actual on-disk size is one block.  OCFS2_MAX_SLOTS is 255,
 * 255 * sizeof(__le16) == 512B, within the 512B block minimum blocksize.
 */
};

# 33 "slot_map.c"
void ocfs2_swap_slot_map(struct ocfs2_slot_map *sm, int num_slots)
{
 int i;

 if (!(!1))
  return;

 for (i = 0; i < num_slots; i++)
  sm->sm_slots[i] = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (sm->sm_slots[i]); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 913 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_refcount_rec {
/*00*/ __le64 r_cpos; /* Physical offset, in clusters */
 __le32 r_clusters; /* Clusters covered by this extent */
 __le32 r_refcount; /* Reference count of this extent */
/*10*/
};

# 924 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_refcount_list {
/*00*/ __le16 rl_count; /* Maximum number of entries possible
				   in rl_records */
 __le16 rl_used; /* Current number of used records */
 __le32 rl_reserved2;
 __le64 rl_reserved1; /* Pad to sizeof(ocfs2_refcount_record) */
/*10*/ struct ocfs2_refcount_rec rl_recs[0]; /* Refcount records */
};

# 934 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_refcount_block {
/*00*/ __u8 rf_signature[8]; /* Signature for verification */
 __le16 rf_suballoc_slot; /* Slot suballocator this block
					   belongs to */
 __le16 rf_suballoc_bit; /* Bit offset in suballocator
					   block group */
 __le32 rf_fs_generation; /* Must match superblock */
/*10*/ __le64 rf_blkno; /* Offset on disk, in blocks */
 __le64 rf_parent; /* Parent block, only valid if
					   OCFS2_REFCOUNT_LEAF_FL is set in
					   rf_flags */
/*20*/ struct ocfs2_block_check rf_check; /* Error checking */
 __le64 rf_last_eb_blk; /* Pointer to last extent block */
/*30*/ __le32 rf_count; /* Number of inodes sharing this
					   refcount tree */
 __le32 rf_flags; /* See the flags above */
 __le32 rf_clusters; /* clusters covered by refcount tree. */
 __le32 rf_cpos; /* cluster offset in refcount tree.*/
/*40*/ __le32 rf_generation; /* generation number. all be the same
					 * for the same refcount tree. */
 __le32 rf_reserved0;
 __le64 rf_suballoc_loc; /* Suballocator block group this
					   refcount block belongs to. Only
					   valid if allocated from a
					   discontiguous block group */
/*50*/ __le64 rf_reserved1[6];
/*80*/ union {
  struct ocfs2_refcount_list rf_records; /* List of refcount
							  records */
  struct ocfs2_extent_list rf_list; /* Extent record list,
							only valid if
							OCFS2_REFCOUNT_TREE_FL
							is set in rf_flags */
 };
/* Actual on-disk size is one block */
};

# 51 "refcount.c"
static void ocfs2_swap_refcount_list_primary(struct ocfs2_refcount_list *rl)
{
 rl->rl_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (rl->rl_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 rl->rl_used = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (rl->rl_used); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 95 "refcount.c"
static void ocfs2_swap_refcount_block_header(struct ocfs2_refcount_block *rb)
{

 rb->rf_suballoc_slot = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (rb->rf_suballoc_slot); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 rb->rf_suballoc_bit = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (rb->rf_suballoc_bit); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 rb->rf_fs_generation = __bswap_32 (rb->rf_fs_generation);
 rb->rf_blkno = __bswap_64 (rb->rf_blkno);
 rb->rf_parent = __bswap_64 (rb->rf_parent);
 rb->rf_last_eb_blk = __bswap_64 (rb->rf_last_eb_blk);
 rb->rf_count = __bswap_32 (rb->rf_count);
 rb->rf_flags = __bswap_32 (rb->rf_flags);
 rb->rf_clusters = __bswap_32 (rb->rf_clusters);
 rb->rf_cpos = __bswap_32 (rb->rf_cpos);
 rb->rf_suballoc_loc = __bswap_64 (rb->rf_suballoc_loc);
}

# 212 "/usr/lib/gcc/i586-linux-gnu/4.9/include/stddef.h"
typedef unsigned int size_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 511 "../include/ocfs2-kernel/ocfs2_fs.h"
struct ocfs2_extent_block
{
/*00*/ __u8 h_signature[8]; /* Signature for verification */
 struct ocfs2_block_check h_check; /* Error checking */
/*10*/ __le16 h_suballoc_slot; /* Slot suballocator this
					   extent_header belongs to */
 __le16 h_suballoc_bit; /* Bit offset in suballocator
					   block group */
 __le32 h_fs_generation; /* Must match super block */
 __le64 h_blkno; /* Offset on disk, in blocks */
/*20*/ __le64 h_suballoc_loc; /* Suballocator block group this
					   eb belongs to.  Only valid
					   if allocated from a
					   discontiguous block group */
 __le64 h_next_leaf_blk; /* Offset on disk, in blocks,
					   of next leaf header pointing
					   to data */
/*30*/ struct ocfs2_extent_list h_list; /* Extent record list */
/* Actual on-disk size is one block */
};

# 1311 "../include/ocfs2/ocfs2.h"
static inline int ocfs2_swap_barrier(ocfs2_filesys *fs, void *block_buffer,
         void *element, size_t element_size)
{
 char *limit, *end;

 limit = block_buffer;
 limit += fs->fs_blocksize;

 end = element;
 end += element_size;

 return end > limit;
}

# 38 "extents.c"
static void ocfs2_swap_extent_list_primary(struct ocfs2_extent_list *el)
{
 el->l_tree_depth = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (el->l_tree_depth); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 el->l_count = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (el->l_count); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 el->l_next_free_rec = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (el->l_next_free_rec); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
}

# 45 "extents.c"
static void ocfs2_swap_extent_list_secondary(ocfs2_filesys *fs, void *obj,
          struct ocfs2_extent_list *el)
{
 uint16_t i;

 for(i = 0; i < el->l_next_free_rec; i++) {
  struct ocfs2_extent_rec *rec = &el->l_recs[i];

  if (ocfs2_swap_barrier(fs, obj, rec,
           sizeof(struct ocfs2_extent_rec)))
   break;

  rec->e_cpos = __bswap_32 (rec->e_cpos);
  if (el->l_tree_depth)
   rec->e_int_clusters = __bswap_32 (rec->e_int_clusters);
  else
   rec->e_leaf_clusters = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (rec->e_leaf_clusters); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
  rec->e_blkno = __bswap_64 (rec->e_blkno);
 }
}

# 85 "extents.c"
static void ocfs2_swap_extent_block_header(struct ocfs2_extent_block *eb)
{

 eb->h_suballoc_slot = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (eb->h_suballoc_slot); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 eb->h_suballoc_bit = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (eb->h_suballoc_bit); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
 eb->h_fs_generation = __bswap_32 (eb->h_fs_generation);
 eb->h_blkno = __bswap_64 (eb->h_blkno);
 eb->h_next_leaf_blk = __bswap_64 (eb->h_next_leaf_blk);
 eb->h_suballoc_loc = __bswap_64 (eb->h_suballoc_loc);
}

