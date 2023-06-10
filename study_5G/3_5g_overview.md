
radio access network와 core network를 어떻게 연결할지에 대한 프로토콜이 매 세대 마다 달랐음
GSM 2G: Frame Relay-based interface(Gb)
WCDMA 3G: ATM-influenced interface(Iu)
LTE 4G: IP-based S1 interface

-> 네트워크 아키텍처 복잡성

5G는 액세스 독립적인 인터페이스 정의, 이전 라디오 액세스 네트워크를 위한 인터페이스, 프로토콜에 대한 지원하지 않음
대신 라디오와 코어 네트워크 상호작용을 정의한 인터페이스 집합(N2 for signaling, N3 for data parts)


---

### device positioning services

5g netowrk arch comes with capa to locate a device using netork capa
two NF that are key to providing these caap
- LMF(Location management)
- GMLC(Gateway Mobile location center)
- also rely on AMF and radio net

process
1. extern app requesting position of device contact GMLC (authorize the req)
2. GMLC query AMF about the position of device
3. if GMLC doesnt know which amf that is serving the device, it will query UDM to find which amf is the one
4. amf query lmf about position
5. lfm return data about position to amf
6. amf forward this to gmlc which forward to extern app

how lmf find/calculate position of device
- interaction with radio net and/or device
- req to radio ent for location info
- network send identity of current cell or make measurements to locate the service

all comm bw lmf and radio net is via amf, conveyed over N2 interace to radio net

comm bw devc and lmf is also done via amf but is carried transparently over radio net within NAS used bw core net and devc

---

### Network analytics

NWDAF(Network data analytics)
- collect many network, subscriber data
- do analysis(statisticla/historical, predict future data values) to this data
- offer the results to other NFs

- collect data from many Nfs using event exposure services offered by these
- also collect from O&M systems as well as subscriber-related data from UDR

- services offered by NWDAF cna be consumed by other NF and extern app(AF), via ENF
- main consumers of the services are NSSF and PCF

- the analyticcs data could be used by other NFs to apply certain actions like selection of specific slice or modification of QoS for a service

---

### Public warning system(PWS)

- natural disasters like earthquakes, storms, etc
can also be used for transmitting road traffic conditions

- support in 5g relies on the usage of Cell broadcasting - the ability to trigger the radio net to transmit one single short message to multiple devices in the net simultaneouslys

- msg are originated in and sent from CBE(Cell Broadcast Entity)

CBC
- controls the transmission area, duration and how frequent re-transmissions shall be made for a given msg

req is sent from CBC to the applicable AMFs over either N50 or SBc interface

why two options?
- if CBC has a service-based interface, service based interfaces are used
	- this interaction using service-based interfaces is visualized as N50 in the logical point-to-point arch. 
	- CBC is strictly called CBCF
- if CBC only has a Diameter interface used for Cell broadcasting over 4G/LTE, SBc is used

AMF
- receives the msg transmission request and sends a corresponding request to all radio based stations within the requestsed geographical area over N2
- as opposed to normal messaging bw the core nwt and the devices like SMS, no interaction bw AMF and devc take place, instead msg is sent from amf to devc via radio net
- reports back to CBC if the transmission was successful or not using reports from radio net

![[Screenshot 2023-06-10 at 10.53.02 AM.png]]

---

### Support for devices connected over non-3GPP access networks

meaning that the device is conn over WiFi acc net
- could be any acc net that is supported by devc and offers IP connectivity

multiple variants of non-3GPP acc support - trusted, untrusted, network-based mobility, host-based mobility

for R15 5g, fewer options are defined for supporting non-3gpp acc
- assume: only untrusted non-3gpp
	- meaning the operator of 3gpp-defined mobile net does not trust the security of non-3gpp acc net
		- obvious bc public/private WiFi net typically use pw-based access authorization methods and sometimes lack payload encryption, which is not acceptable for permitting access to mobile net infra

in R16, included support for trusted non-3gpp acc net as well as wireline acc

5gc includes 
- the N3IWF(Non-3gpp interWorking) acts as a gateway to mobile net
- connection point for devices that gain access over a non-3gpp acc net
note: bc this is about untrusted access, the arc doesnt specify how a non-3gpp acc net is conn to 5gc, it instead specifies hwo devices utilizing any untrusted non-3gpp access net to 5gc using N3IWF NF

![[Screenshot 2023-06-10 at 11.18.04 AM.png]]

 devc conn to non-3gpp net, is authorized, granted access and given IP addr
 - this conn is referred to as Y1
 note: how and when this is done is out of operator's control nor it is specified by 3gpp

Y1 is typically a WiFi air interface

devc selects an N3IWF and conn to this N3IWF using IP acc service offered by the non-3gpp net
- this conn is referred to as Y2 (not specified by 3gpp)
- Y2 may well be the public Internet
- then a secure and encrypted IPsec tunnel is established bw devc and N3IWF, thru which both signlaing and data traffic bw devc and mobile net can be forwarded
- this tunnel is referred to as NWu

N3IWF selects an AMF
- N2 interfaces is estb bw N3IWF and the selected AMF
- then N1 interface carrying NAS signaling is estb bw devc and AMF
- NAS signaling no longer only apply to 3gpp acc nets as in the EPC arch.
- so NAS signaling is carried over N1, across NWu and N2, between devc and AMF and NWu is the tunnel on top of Y1, the non-3gpp acc net, and Y2

once a UPF is selected, an N3 interface bw N3IWF and UPF is estb for data transmission
- data is carried over NWu bw devc and N3IWF and then across N3 bw N3IWF and UPF

![[Screenshot 2023-06-10 at 11.41.48 AM.png]]

devc can be simultaneously registered over both 3gpp and non-3gpp acc
- also simultaneously have two sessions active over 3gpp and non-3gpp (16, not 15)

---

### Network slicing

separate traffic into multiple logical networks that all execute on and share a common physical infra
- for secutiy, to optimie the config and the network topology differently for different services, or to enable a differentiation between operator service offerings

a network slice consists of a radio net and a core net

new 5gc allow a single device to connect to more tha n one slice simultaneously

a network slice 
- is identified by a parameter called S-NSSAI(Single Network Slice Selection Assistance Information)
- consists of two sub params - SST(Slice/Service Type), optional SD(Slice Differentiator)
	- SD is used to differentiate between multiple slices of the same type, hence having the same SST

radio net serving devc will use one or more S-NSSAI values requested by devc to do the initial selection of AMF

the selected AMF will either decide to servce the specific device or make a new slice selection itself
- it may use NSSF for this

as its single role, NSSF has to support the selection of network slices based on a combination of S-NSSAI values

![[Screenshot 2023-06-10 at 11.56.43 AM.png]]
UE2 simultaneously conn to slice 2 and 3, each of these containing an SMF and UPF but both being served by a common AMF2

---

### Roaming

support for connecting networks from two operators to support subscriber roaming

some NF remain in the network where the user is attaching(VPLMN), some NFs will exist in the network where the user is a subscriber(HPLMN), some NFs become duplicated

SEPP(Security Edge protection proxy)
- to achieve a secure conn bw VPLMN and HPLMN
- not NF, act as a service relay bw consumer and producer when these two NF are in diff networks

---

### Storage of data

UDSF(Unstructured(unspecified, implementation-specific per vendor) data storage)
- can be viewed as being in a gray zeon, as it is specified as a generic database component in the arch, allowing for any NF to store and retrieve any of its data using UDSF
- several NF may share one single UDSF or they may use separate UDFSs
- provide services to other NFs over Nudfs reference point


---

### 5G radio networks

#### overview
![[Screenshot 2023-06-10 at 1.46.23 PM.png]]