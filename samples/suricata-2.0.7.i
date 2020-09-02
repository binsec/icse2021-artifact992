unsigned int __builtin_bswap32 (unsigned int);

# 48 "/usr/include/stdint.h"
typedef unsigned char uint8_t;

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 181 "decode-tcp.h"
static inline uint16_t TCPCalculateChecksum(uint16_t *shdr, uint16_t *pkt,
                                            uint16_t tlen)
{
    uint16_t pad = 0;
    uint32_t csum = shdr[0];

    csum += shdr[1] + shdr[2] + shdr[3] + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (6); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (tlen); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
        pkt[7] + pkt[9];

    tlen -= 20;
    pkt += 10;

    while (tlen >= 32) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
            pkt[7] + pkt[8] + pkt[9] + pkt[10] + pkt[11] + pkt[12] + pkt[13] +
            pkt[14] + pkt[15];
        tlen -= 32;
        pkt += 16;
    }

    while(tlen >= 8) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3];
        tlen -= 8;
        pkt += 4;
    }

    while(tlen >= 4) {
        csum += pkt[0] + pkt[1];
        tlen -= 4;
        pkt += 2;
    }

    while (tlen > 1) {
        csum += pkt[0];
        pkt += 1;
        tlen -= 2;
    }

    if (tlen == 1) {
        *(uint8_t *)(&pad) = (*(uint8_t *)pkt);
        csum += pad;
    }

    csum = (csum >> 16) + (csum & 0x0000FFFF);
    csum += (csum >> 16);

    return (uint16_t)~csum;
}

# 242 "decode-tcp.h"
static inline uint16_t TCPV6CalculateChecksum(uint16_t *shdr, uint16_t *pkt,
                                       uint16_t tlen)
{
    uint16_t pad = 0;
    uint32_t csum = shdr[0];

    csum += shdr[1] + shdr[2] + shdr[3] + shdr[4] + shdr[5] + shdr[6] +
        shdr[7] + shdr[8] + shdr[9] + shdr[10] + shdr[11] + shdr[12] +
        shdr[13] + shdr[14] + shdr[15] + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (6); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (tlen); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
        pkt[7] + pkt[9];

    tlen -= 20;
    pkt += 10;

    while (tlen >= 32) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
            pkt[7] + pkt[8] + pkt[9] + pkt[10] + pkt[11] + pkt[12] + pkt[13] +
            pkt[14] + pkt[15];
        tlen -= 32;
        pkt += 16;
    }

    while(tlen >= 8) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3];
        tlen -= 8;
        pkt += 4;
    }

    while(tlen >= 4) {
        csum += pkt[0] + pkt[1];
        tlen -= 4;
        pkt += 2;
    }

    while (tlen > 1) {
        csum += pkt[0];
        pkt += 1;
        tlen -= 2;
    }

    if (tlen == 1) {
        *(uint8_t *)(&pad) = (*(uint8_t *)pkt);
        csum += pad;
    }

    csum = (csum >> 16) + (csum & 0x0000FFFF);
    csum += (csum >> 16);

    return (uint16_t)~csum;
}

# 72 "decode-udp.h"
static inline uint16_t UDPV4CalculateChecksum(uint16_t *shdr, uint16_t *pkt,
                                              uint16_t tlen)
{
    uint16_t pad = 0;
    uint32_t csum = shdr[0];

    csum += shdr[1] + shdr[2] + shdr[3] + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (17); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (tlen); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    csum += pkt[0] + pkt[1] + pkt[2];

    tlen -= 8;
    pkt += 4;

    while (tlen >= 32) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
            pkt[7] + pkt[8] + pkt[9] + pkt[10] + pkt[11] + pkt[12] + pkt[13] +
            pkt[14] + pkt[15];
        tlen -= 32;
        pkt += 16;
    }

    while(tlen >= 8) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3];
        tlen -= 8;
        pkt += 4;
    }

    while(tlen >= 4) {
        csum += pkt[0] + pkt[1];
        tlen -= 4;
        pkt += 2;
    }

    while (tlen > 1) {
        csum += pkt[0];
        pkt += 1;
        tlen -= 2;
    }

    if (tlen == 1) {
        *(uint8_t *)(&pad) = (*(uint8_t *)pkt);
        csum += pad;
    }

    csum = (csum >> 16) + (csum & 0x0000FFFF);
    csum += (csum >> 16);

    uint16_t csum_u16 = (uint16_t)~csum;
    if (csum_u16 == 0)
        return 0xFFFF;
    else
        return csum_u16;
}

# 136 "decode-udp.h"
static inline uint16_t UDPV6CalculateChecksum(uint16_t *shdr, uint16_t *pkt,
                                              uint16_t tlen)
{
    uint16_t pad = 0;
    uint32_t csum = shdr[0];

    csum += shdr[1] + shdr[2] + shdr[3] + shdr[4] + shdr[5] + shdr[6] +
        shdr[7] + shdr[8] + shdr[9] + shdr[10] + shdr[11] + shdr[12] +
        shdr[13] + shdr[14] + shdr[15] + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (17); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; })) + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (tlen); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    csum += pkt[0] + pkt[1] + pkt[2];

    tlen -= 8;
    pkt += 4;

    while (tlen >= 32) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
            pkt[7] + pkt[8] + pkt[9] + pkt[10] + pkt[11] + pkt[12] + pkt[13] +
            pkt[14] + pkt[15];
        tlen -= 32;
        pkt += 16;
    }

    while(tlen >= 8) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3];
        tlen -= 8;
        pkt += 4;
    }

    while(tlen >= 4) {
        csum += pkt[0] + pkt[1];
        tlen -= 4;
        pkt += 2;
    }

    while (tlen > 1) {
        csum += pkt[0];
        pkt += 1;
        tlen -= 2;
    }

    if (tlen == 1) {
        *(uint8_t *)(&pad) = (*(uint8_t *)pkt);
        csum += pad;
    }

    csum = (csum >> 16) + (csum & 0x0000FFFF);
    csum += (csum >> 16);

    uint16_t csum_u16 = (uint16_t)~csum;
    if (csum_u16 == 0)
        return 0xFFFF;
    else
        return csum_u16;
}

# 195 "decode-icmpv6.h"
static inline uint16_t ICMPV6CalculateChecksum(uint16_t *shdr, uint16_t *pkt,
                                        uint16_t tlen)
{
    uint16_t pad = 0;
    uint32_t csum = shdr[0];

    csum += shdr[1] + shdr[2] + shdr[3] + shdr[4] + shdr[5] + shdr[6] +
        shdr[7] + shdr[8] + shdr[9] + shdr[10] + shdr[11] + shdr[12] +
        shdr[13] + shdr[14] + shdr[15] + (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (58 + tlen); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));

    csum += pkt[0];

    tlen -= 4;
    pkt += 2;

    while (tlen >= 64) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
            pkt[7] + pkt[8] + pkt[9] + pkt[10] + pkt[11] + pkt[12] + pkt[13] +
            pkt[14] + pkt[15] + pkt[16] + pkt[17] + pkt[18] + pkt[19] +
            pkt[20] + pkt[21] + pkt[22] + pkt[23] + pkt[24] + pkt[25] +
            pkt[26] + pkt[27] + pkt[28] + pkt[29] + pkt[30] + pkt[31];
        tlen -= 64;
        pkt += 32;
    }

    while (tlen >= 32) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3] + pkt[4] + pkt[5] + pkt[6] +
            pkt[7] + pkt[8] + pkt[9] + pkt[10] + pkt[11] + pkt[12] + pkt[13] +
            pkt[14] + pkt[15];
        tlen -= 32;
        pkt += 16;
    }

    while(tlen >= 8) {
        csum += pkt[0] + pkt[1] + pkt[2] + pkt[3];
        tlen -= 8;
        pkt += 4;
    }

    while(tlen >= 4) {
        csum += pkt[0] + pkt[1];
        tlen -= 4;
        pkt += 2;
    }

    while (tlen > 1) {
        csum += pkt[0];
        tlen -= 2;
        pkt += 1;
    }

    if (tlen == 1) {
        *(uint8_t *)(&pad) = (*(uint8_t *)pkt);
        csum += pad;
    }

    csum = (csum >> 16) + (csum & 0x0000FFFF);
    csum += (csum >> 16);

    return (uint16_t) ~csum;
}

# 44 "/usr/include/i386-linux-gnu/bits/byteswap.h"
static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}

# 97 "app-layer-dcerpc-common.h"
typedef struct DCERPCHdr_ {
    uint8_t rpc_vers; /**< 00:01 RPC version should be 5 */
    uint8_t rpc_vers_minor; /**< 01:01 minor version */
    uint8_t type; /**< 02:01 packet type */
    uint8_t pfc_flags; /**< 03:01 flags (see PFC_... ) */
    uint8_t packed_drep[4]; /**< 04:04 NDR data representation format label */
    uint16_t frag_length; /**< 08:02 total length of fragment */
    uint16_t auth_length; /**< 10:02 length of auth_value */
    uint32_t call_id; /**< 12:04 call identifier */
} DCERPCHdr;

# 137 "app-layer-dcerpc-common.h"
typedef struct DCERPCUuidEntry_ {
    uint16_t ctxid;
    uint16_t internal_id;
    uint16_t result;
    uint8_t uuid[16];
    uint16_t version;
    uint16_t versionminor;
    uint16_t flags; /**< DCERPC_UUID_ENTRY_FLAG_* flags */
    struct { struct DCERPCUuidEntry_ *tqe_next; /* next element */ struct DCERPCUuidEntry_ **tqe_prev; /* address of previous next element */ } next;
} DCERPCUuidEntry;

# 148 "app-layer-dcerpc-common.h"
typedef struct DCERPCBindBindAck_ {
    uint8_t numctxitems;
    uint8_t numctxitemsleft;
    uint8_t ctxbytesprocessed;
    uint16_t ctxid;
    uint8_t uuid[16];
    uint16_t version;
    uint16_t versionminor;
    DCERPCUuidEntry *uuid_entry;
    struct { struct DCERPCUuidEntry_ *tqh_first; /* first element */ struct DCERPCUuidEntry_ **tqh_last; /* addr of last next element */ } uuid_list;
    /* the interface uuids that the server has accepted */
    struct { struct DCERPCUuidEntry_ *tqh_first; /* first element */ struct DCERPCUuidEntry_ **tqh_last; /* addr of last next element */ } accepted_uuid_list;
    uint16_t uuid_internal_id;
    uint16_t secondaryaddrlen;
    uint16_t secondaryaddrlenleft;
    uint16_t result;
} DCERPCBindBindAck;

# 166 "app-layer-dcerpc-common.h"
typedef struct DCERPCRequest_ {
    uint16_t ctxid;
    uint16_t opnum;
    /* holds the stub data for the request */
    uint8_t *stub_data_buffer;
    /* length of the above buffer */
    uint32_t stub_data_buffer_len;
    /* used by the dce preproc to indicate fresh entry in the stub data buffer */
    uint8_t stub_data_fresh;
    uint8_t first_request_seen;
} DCERPCRequest;

# 178 "app-layer-dcerpc-common.h"
typedef struct DCERPCResponse_ {
    /* holds the stub data for the response */
    uint8_t *stub_data_buffer;
    /* length of the above buffer */
    uint32_t stub_data_buffer_len;
    /* used by the dce preproc to indicate fresh entry in the stub data buffer */
    uint8_t stub_data_fresh;
} DCERPCResponse;

# 187 "app-layer-dcerpc-common.h"
typedef struct DCERPC_ {
    DCERPCHdr dcerpchdr;
    DCERPCBindBindAck dcerpcbindbindack;
    DCERPCRequest dcerpcrequest;
    DCERPCResponse dcerpcresponse;
    uint16_t bytesprocessed;
    uint8_t pad;
    uint16_t padleft;
    uint16_t transaction_id;
    /* indicates if the dcerpc pdu state is in the middle of processing
     * a fragmented pdu */
    uint8_t pdu_fragged;
} DCERPC;

# 990 "app-layer-dcerpc.c"
static uint32_t DCERPCParseBINDACK(DCERPC *dcerpc, uint8_t *input, uint32_t input_len) {
    ;
    uint8_t *p = input;

    switch (dcerpc->bytesprocessed) {
        case 16:
            dcerpc->dcerpcbindbindack.uuid_internal_id = 0;
            dcerpc->dcerpcbindbindack.numctxitems = 0;
            if (input_len >= 10) {
                if (dcerpc->dcerpchdr.packed_drep[0] & 0x10) {
                    dcerpc->dcerpcbindbindack.secondaryaddrlen = *(p + 8);
                    dcerpc->dcerpcbindbindack.secondaryaddrlen |= *(p + 9) << 8;
                } else {
                    dcerpc->dcerpcbindbindack.secondaryaddrlen = *(p + 8) << 8;
                    dcerpc->dcerpcbindbindack.secondaryaddrlen |= *(p + 9);
                }
                dcerpc->dcerpcbindbindack.secondaryaddrlenleft = dcerpc->dcerpcbindbindack.secondaryaddrlen;
                dcerpc->bytesprocessed += 10;
                return 10U;
            } else {
                /* max_xmit_frag */
                p++;
                if (!(--input_len))
                    break;
            }
            /* fall through */
        case 17:
            /* max_xmit_frag */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 18:
            /* max_recv_frag */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 19:
            /* max_recv_frag */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 20:
            /* assoc_group_id */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 21:
            /* assoc_group_id */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 22:
            /* assoc_group_id */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 23:
            /* assoc_group_id */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 24:
            dcerpc->dcerpcbindbindack.secondaryaddrlen = *(p++) << 8;
            if (!(--input_len))
                break;
            /* fall through */
        case 25:
            dcerpc->dcerpcbindbindack.secondaryaddrlen |= *(p++);
            if (dcerpc->dcerpchdr.packed_drep[0] & 0x10) {
                dcerpc->dcerpcbindbindack.secondaryaddrlen = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dcerpc->dcerpcbindbindack.secondaryaddrlen); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
            }
            dcerpc->dcerpcbindbindack.secondaryaddrlenleft = dcerpc->dcerpcbindbindack.secondaryaddrlen;
            do { } while (0)
                                                               ;
            --input_len;
            break;
        default:
            dcerpc->bytesprocessed++;
            return 1;
            break;
    }
    dcerpc->bytesprocessed += (p - input);
    return (uint32_t)(p - input);
}

# 1082 "app-layer-dcerpc.c"
static uint32_t DCERPCParseREQUEST(DCERPC *dcerpc, uint8_t *input, uint32_t input_len) {
    ;
    uint8_t *p = input;

    switch (dcerpc->bytesprocessed) {
        case 16:
            dcerpc->dcerpcbindbindack.numctxitems = 0;
            if (input_len >= 8) {
                if (dcerpc->dcerpchdr.type == 0) {
                    if (dcerpc->dcerpchdr.packed_drep[0] & 0x10) {
                        dcerpc->dcerpcrequest.ctxid = *(p + 4);
                        dcerpc->dcerpcrequest.ctxid |= *(p + 5) << 8;
                        dcerpc->dcerpcrequest.opnum = *(p + 6);
                        dcerpc->dcerpcrequest.opnum |= *(p + 7) << 8;
                    } else {
                        dcerpc->dcerpcrequest.ctxid = *(p + 4) << 8;
                        dcerpc->dcerpcrequest.ctxid |= *(p + 5);
                        dcerpc->dcerpcrequest.opnum = *(p + 6) << 8;
                        dcerpc->dcerpcrequest.opnum |= *(p + 7);
                    }
                    dcerpc->dcerpcrequest.first_request_seen = 1;
                }
                dcerpc->bytesprocessed += 8;
                return 8U;
            } else {
                /* alloc hint 1 */
                p++;
                if (!(--input_len))
                    break;
            }
            /* fall through */
        case 17:
            /* alloc hint 2 */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 18:
            /* alloc hint 3 */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 19:
            /* alloc hint 4 */
            p++;
            if (!(--input_len))
                break;
            /* fall through */
        case 20:
            /* context id 1 */
            dcerpc->dcerpcrequest.ctxid = *(p++);
            if (!(--input_len))
                break;
            /* fall through */
        case 21:
            /* context id 2 */
            dcerpc->dcerpcrequest.ctxid |= *(p++) << 8;
            if (!(dcerpc->dcerpchdr.packed_drep[0] & 0x10)) {
                dcerpc->dcerpcrequest.ctxid = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dcerpc->dcerpcrequest.ctxid); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
            }
            dcerpc->dcerpcrequest.first_request_seen = 1;
            if (!(--input_len))
                break;
            /* fall through */
        case 22:
            if (dcerpc->dcerpchdr.type == 0) {
                dcerpc->dcerpcrequest.opnum = *(p++);
            } else {
                p++;
            }
            if (!(--input_len))
                break;
            /* fall through */
        case 23:
            if (dcerpc->dcerpchdr.type == 0) {
                dcerpc->dcerpcrequest.opnum |= *(p++) << 8;
                if (!(dcerpc->dcerpchdr.packed_drep[0] & 0x10)) {
                    dcerpc->dcerpcrequest.opnum = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dcerpc->dcerpcrequest.opnum); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                }
            } else {
                p++;
            }
            --input_len;
            break;
        default:
            dcerpc->bytesprocessed++;
            return 1;
            break;
    }
    dcerpc->bytesprocessed += (p - input);
    return (uint32_t)(p - input);
}

# 1272 "app-layer-dcerpc.c"
static int DCERPCParseHeader(DCERPC *dcerpc, uint8_t *input, uint32_t input_len) {
    ;
    uint8_t *p = input;

    if (input_len) {
        do { } while (0);
        switch (dcerpc->bytesprocessed) {
            case 0:
                if (input_len >= 16) {
                    dcerpc->dcerpchdr.rpc_vers = *p;
                    dcerpc->dcerpchdr.rpc_vers_minor = *(p + 1);
                    if ((dcerpc->dcerpchdr.rpc_vers != 5) ||
                       ((dcerpc->dcerpchdr.rpc_vers_minor != 0) &&
                       (dcerpc->dcerpchdr.rpc_vers_minor != 1))) {
       do { } while (0);
       return -1;
                    }
                    dcerpc->dcerpchdr.type = *(p + 2);
                    do { } while (0)
                                                   ;
                    dcerpc->dcerpchdr.pfc_flags = *(p + 3);
                    dcerpc->dcerpchdr.packed_drep[0] = *(p + 4);
                    dcerpc->dcerpchdr.packed_drep[1] = *(p + 5);
                    dcerpc->dcerpchdr.packed_drep[2] = *(p + 6);
                    dcerpc->dcerpchdr.packed_drep[3] = *(p + 7);
                    if (dcerpc->dcerpchdr.packed_drep[0] & 0x10) {
                        dcerpc->dcerpchdr.frag_length = *(p + 8);
                        dcerpc->dcerpchdr.frag_length |= *(p + 9) << 8;
                        dcerpc->dcerpchdr.auth_length = *(p + 10);
                        dcerpc->dcerpchdr.auth_length |= *(p + 11) << 8;
                        dcerpc->dcerpchdr.call_id = *(p + 12) << 24;
                        dcerpc->dcerpchdr.call_id |= *(p + 13) << 16;
                        dcerpc->dcerpchdr.call_id |= *(p + 14) << 8;
                        dcerpc->dcerpchdr.call_id |= *(p + 15);
                    } else {
                        dcerpc->dcerpchdr.frag_length = *(p + 8) << 8;
                        dcerpc->dcerpchdr.frag_length |= *(p + 9);
                        dcerpc->dcerpchdr.auth_length = *(p + 10) << 8;
                        dcerpc->dcerpchdr.auth_length |= *(p + 11);
                        dcerpc->dcerpchdr.call_id = *(p + 12);
                        dcerpc->dcerpchdr.call_id |= *(p + 13) << 8;
                        dcerpc->dcerpchdr.call_id |= *(p + 14) << 16;
                        dcerpc->dcerpchdr.call_id |= *(p + 15) << 24;
                    }
                    dcerpc->bytesprocessed = 16;
                    return 16;
                    break;
                } else {
                    dcerpc->dcerpchdr.rpc_vers = *(p++);
                    if (!(--input_len))
                        break;
                }
                /* fall through */
            case 1:
                dcerpc->dcerpchdr.rpc_vers_minor = *(p++);
                if ((dcerpc->dcerpchdr.rpc_vers != 5) ||
                    ((dcerpc->dcerpchdr.rpc_vers_minor != 0) &&
                    (dcerpc->dcerpchdr.rpc_vers_minor != 1))) {
      do { } while (0);
      return -1;
                }
                if (!(--input_len))
                    break;
                /* fall through */
            case 2:
                dcerpc->dcerpchdr.type = *(p++);
                do { } while (0)
                                               ;
                if (!(--input_len))
                    break;
                /* fall through */
            case 3:
                dcerpc->dcerpchdr.pfc_flags = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 4:
                dcerpc->dcerpchdr.packed_drep[0] = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 5:
                dcerpc->dcerpchdr.packed_drep[1] = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 6:
                dcerpc->dcerpchdr.packed_drep[2] = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 7:
                dcerpc->dcerpchdr.packed_drep[3] = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 8:
                dcerpc->dcerpchdr.frag_length = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 9:
                dcerpc->dcerpchdr.frag_length |= *(p++) << 8;
                if (!(--input_len))
                    break;
                /* fall through */
            case 10:
                dcerpc->dcerpchdr.auth_length = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 11:
                dcerpc->dcerpchdr.auth_length |= *(p++) << 8;
                if (!(--input_len))
                    break;
                /* fall through */
            case 12:
                dcerpc->dcerpchdr.call_id = *(p++);
                if (!(--input_len))
                    break;
                /* fall through */
            case 13:
                dcerpc->dcerpchdr.call_id |= *(p++) << 8;
                if (!(--input_len))
                    break;
                /* fall through */
            case 14:
                dcerpc->dcerpchdr.call_id |= *(p++) << 16;
                if (!(--input_len))
                    break;
                /* fall through */
            case 15:
                dcerpc->dcerpchdr.call_id |= *(p++) << 24;
                if (!(dcerpc->dcerpchdr.packed_drep[0] & 0x10)) {
                    dcerpc->dcerpchdr.frag_length = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dcerpc->dcerpchdr.frag_length); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                    dcerpc->dcerpchdr.auth_length = (__extension__ ({ unsigned short int __v, __x = (unsigned short int) (dcerpc->dcerpchdr.auth_length); if (__builtin_constant_p (__x)) __v = ((unsigned short int) ((((__x) >> 8) & 0xff) | (((__x) & 0xff) << 8))); else __asm__ ("rorw $8, %w0" : "=r" (__v) : "0" (__x) : "cc"); __v; }));
                    dcerpc->dcerpchdr.call_id = __bswap_32 (dcerpc->dcerpchdr.call_id);
                }
                --input_len;
                break;
            default:
                dcerpc->bytesprocessed++;
                return 1;
        }
    }
    dcerpc->bytesprocessed += (p - input);
    return (p - input);
}

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 189 "util-cpu.c"
uint64_t UtilCpuGetTicks(void)
{
    uint64_t val;







    __asm__ __volatile__ (
    "xorl %%eax,%%eax\n\t"
    "pushl %%ebx\n\t"
    "cpuid\n\t"
    "popl %%ebx\n\t"
    ::: "%eax", "%ecx", "%edx");

    uint32_t a, d;
    __asm__ __volatile__ ("rdtsc" : "=a" (a), "=d" (d));
    val = ((uint64_t)a) | (((uint64_t)d) << 32);






    __asm__ __volatile__ (
    "xorl %%eax,%%eax\n\t"
    "pushl %%ebx\n\t"
    "cpuid\n\t"
    "popl %%ebx\n\t"
    ::: "%eax", "%ecx", "%edx");
# 229 "util-cpu.c"
    return val;
}

