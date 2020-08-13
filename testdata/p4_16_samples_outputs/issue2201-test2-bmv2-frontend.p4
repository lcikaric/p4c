#include <core.p4>
#define V1MODEL_VERSION 20180101
#include <v1model.p4>

typedef bit<48> EthernetAddress;
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}

struct headers_t {
    ethernet_t ethernet;
}

struct metadata_t {
}

header Header {
    bit<7> val1;
    bool   val2;
}

struct Structure1 {
    bit<8> val1;
    bit<8> val2;
    bool   val3;
}

struct Structure2 {
    int<7> val1;
    Header val2;
}

struct Structure3 {
    bool       val1;
    Header     val2;
    int<4>     val3;
    Header     val4;
    Structure1 val5;
}

parser parserImpl(packet_in packet, out headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    state start {
        packet.extract<ethernet_t>(hdr.ethernet);
        transition accept;
    }
}

control verifyChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply {
    }
}

control ingressImpl(inout headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    @name("ingressImpl.str1") Structure1 str1_0;
    @name("ingressImpl.hdr1") Header hdr1_0;
    @name("ingressImpl.str2") Structure2 str2_0;
    @name("ingressImpl.hdr2") Header hdr2_0;
    @name("ingressImpl.str3") Structure3 str3_0;
    apply {
        str1_0 = (Structure1){val1 = 8w2,val2 = 8w3,val3 = false};
        log_msg<tuple<Structure1>>("str1 = {}", { str1_0 });
        hdr1_0.setValid();
        hdr1_0 = (Header){val1 = 7w4,val2 = true};
        str2_0 = (Structure2){val1 = 7s3,val2 = hdr1_0};
        log_msg<tuple<Structure2>>("str2 = {}", { str2_0 });
        hdr2_0.setValid();
        hdr2_0 = (Header){val1 = 7w3,val2 = false};
        str3_0 = (Structure3){val1 = true,val2 = hdr1_0,val3 = -4s2,val4 = hdr2_0,val5 = str1_0};
        log_msg<tuple<Structure3>>("str3 = {}", { str3_0 });
    }
}

control egressImpl(inout headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    apply {
    }
}

control updateChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply {
    }
}

control deparserImpl(packet_out packet, in headers_t hdr) {
    apply {
        packet.emit<ethernet_t>(hdr.ethernet);
    }
}

V1Switch<headers_t, metadata_t>(parserImpl(), verifyChecksum(), ingressImpl(), egressImpl(), updateChecksum(), deparserImpl()) main;

