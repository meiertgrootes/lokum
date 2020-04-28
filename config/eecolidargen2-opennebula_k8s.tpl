CONTEXT = [
  DNS_HOSTNAME = "YES",
  NETWORK = "YES",
  SSH_PUBLIC_KEY = "${file("/lokum/id_rsa_lokum_root.key.pub")}",
  USERNAME = "root"]
CPU = "4.0"
VCPU = "4"
DISK = [
  DATASTORE = "local_images_ssd",
  DATASTORE_ID = "104",
  IMAGE_ID = "23518",
  SIZE = "15360",
  TYPE= "fs" ]
DISK = [
  DATASTORE = "local_system_ssd",
  DATASTORE_ID = "103",
  DISK_TYPE = "FILE",
  FORMAT = "raw",
  SIZE = "71680",
  TARGET = "vdb",
  TYPE = "fs" ]
DISK = [
  DATASTORE = "local_system_ssd",
  DATASTORE_ID = "103",
  DISK_TYPE = "FILE",
  SIZE = "49152",
  TARGET = "vdc",
  TYPE = "swap" ]
GRAPHICS = [
  LISTEN = "0.0.0.0",
  TYPE = "VNC" ]
INPUTS_ORDER = ""
MEMORY = "32768"
MEMORY_UNIT_COST = "MB"
NIC = [
  NETWORK = "internet",
  NETWORK_UNAME = "oneadmin" ]
OS = [
  ARCH = "x86_64",
  BOOT = "" ]
