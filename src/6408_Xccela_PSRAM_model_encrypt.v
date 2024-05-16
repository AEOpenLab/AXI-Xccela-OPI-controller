
// *******************************************************************************************************

`timescale 1ns/10ps

`define tCLK5000



`define tDQSCKmin	2 	// fixed 2

`define tHZ 		4
`define tDQSCK		3	// range 2-5.5ns (should use max for model delivery)
`define tDQSQ		0.4	// max 0.4ns @200, 0.5ns @166, 0.6ns @133
`define tRC		60

module psram_model (xDQ, xDQSDM, xCEn, xCLK, xRESETn);

`ifdef tCLK5000
	parameter CLOCK_MHZ = 200;
	parameter tCLKmin	= 5;
	parameter tDQSCKmax	= 5.5;			// should be used for timing checks only, and not model output behaviour
	parameter tDQSQmax	= 0.4;			// should be used for timing checks only, and not model output behaviour
`else
`ifdef tCLK6000
	parameter CLOCK_MHZ = 166;
	parameter tCLKmin	= 6;
	parameter tDQSCKmax	= 5.5;			// should be used for timing checks only, and not model output behaviour
	parameter tDQSQmax	= 0.5;			// should be used for timing checks only, and not model output behaviour
//`else `define tCLK7500
`else
	parameter CLOCK_MHZ = 133;
	parameter tCLKmin	= 7.5;
	parameter tDQSCKmax	= 5.5;			// should be used for timing checks only, and not model output behaviour
	parameter tDQSQmax	= 0.6;			// should be used for timing checks only, and not model output behaviour
`endif
`endif
	parameter tCQLZmax	= 6;
	parameter tCHmin	= 0.45;
	parameter tCHmax	= 0.55;
	parameter tCLmin	= 0.45;
	parameter tCLmax	= 0.55;
	parameter tCEMmax	= 4_000;		// standard temp.  Use 1_000 for extended temp
	parameter tCEMmin	= 3;
	parameter tPU		= 150_000;
	parameter tHS		= 4_000;
	parameter tXHS		= 100_000;
	parameter tXPHS		= 60;

`protected
    MTI!#C>DGTE\^G<v@1_v~_$Urx^?!}'>J5!'BFqgl1iT!e5iD*Oj}X}Y^XT[bo_K<}^=<)>X{^YH
    H*'JB$lL^i!xQ-1_D8lwTRs3[[upXIpw]aoBp!;BDu}}au%sVkpBuel_WJ#UB5URKOX{XO1zoXs7
    EVvpgR#eBBuovvV{@Om[Tka\7FxkrwGXDYc
`endprotected


   input                xCLK;                           // serial data clock
   input                xCEn;                           // chip select - active low
   input                xRESETn;                        // reset# - active low
   inout                xDQSDM;                         // Data strobe/mask
   inout [7:0]          xDQ;                            // Data/Address In/out

//////////////////////////////////////////////////

reg [31:0] psram_CLOCK_MHZ;
assign  psram_CLOCK_MHZ = CLOCK_MHZ;

//////////////////////////////////////////////////

// *******************************************************************************************************
// **   DECLARATIONS                                                                                    **
// *******************************************************************************************************

   reg  [23:00]         DataShifterI;                   // serial input data shifter
   reg  [15:00]         BitCounter;                     // serial input bit counter
   reg  [07:00]         InstRegister;                   // instruction register
   reg  [31:00]         AddrRegister;                   // 32-bit address register
	parameter row_width 	= 13;
	parameter col_width 	= 10;
	parameter memad_width 	= row_width+col_width;
	parameter memad_size 	= 1 << memad_width;
   reg [row_width-1:0]		RowAddrin;
   reg [col_width-1:0]		ColAddrin;
   reg [row_width-1:0]		RowAddr;
   reg [col_width-1:0]		ColAddr;
   wire [memad_width-1:0]	MemAddr;

   wire                 InstructionREAD;                // decoded instruction byte
   wire                 InstructionRDSR;                // decoded instruction byte
   wire                 InstructionWRSR;                // decoded instruction byte
   wire                 InstructionWRITE;               // decoded instruction byte
   wire                 InstructionLinear;              // decoded instruction byte
   wire                 InstructionGBLRST;              // decoded instruction byte
   wire                 InstructionRDID;                // decoded instruction byte

   reg  [07:00]         MemoryBlock [0:memad_size-1];
   
        parameter VeriOutStr    = 0;	// use 1 if host is using bus keepers

`protected
    MTI!#|\xnw^RC]a'[a_ACz[z*5K[_!UV2W!<oi];K'7;[5||#}[[aAm~0ln-5[3K$piokF~$?WG~
    H{_X[#6DIDVgBfom-x,@Iv!RBp=rwp+*=oVCv?pG{Xm]kmxnoAgL^6*-W$A<mBvPBl_xBA\Kk[a\
    QAIQyEu_nGRIw?1KO!v{W3AAD4Bl'O=;7Xi1WH2=T=kjo\;E~<aep2as~!['~p^vJ7nI>@Z^Vl@[
    }]?YD3[;+\bBsY1?R;!'^$TV#l!BU1XSPo2v@Q;Q{n7!pJxT[*C;Z!T[5+r\ARZ~Tj!ZR15Z,u1p
    51VXuY>Es=?7s#$AT-sD$jK>>C!T=Iskr+V-E$Dn3
`endprotected


   reg  [7:0]           SR[0:8];
   reg	[7:0]		MROut[1:0];
   reg  [3:0]		MA1;
   wire [7:0]           SR0;
   wire [7:0]           SR1;
   wire [7:0]           SR4;
   wire [7:0]           SR8;
   reg  [7:0]           DOUT;
   reg  [7:0]           DOUT_d;
   
   reg                  SO_Enable;
   reg                  DQS_OE_Enable;
   wire                 OutputEnable;

`protected
    MTI!#1KrOrG5r,?rWXDV,OEo~^+CBV;zz\V2$7mBV*P0i>}Uot)<a+sl#Ws^xjpr$DrgID##O?GI
    [v#Yjl1W]-[V}TG@lm7ww-^@[Y=@-Ex+T*?ua{K7Xl<{{UK^:X=22>T>@#[~]mOnkvhV=iIB#+kh
    wqTTGZBKwk{<C2BG]iB\*!2Ye!xYkjO}5zWaJx7-HYLq",_tnDr,KA!+Pua2HgrJ\AuI[{krr2^%
    ca^YB]u-3=m*-}o@eezJ<=lz~upVY71JE7=kz2=RmsG_YVovmu}\eroW#O_wAK',iF:E-Cup2=a|
    E3,TpmDzps#rDKlvrXp;
`endprotected


   integer		errors, warnings;

`protected
    MTI!#>_!A5E*Q=G-^Ba}_<E+G~YB7S,W7Cap0r#|N/7'}u1*o[t_i-#1)vr\-?'orCl[!>Tnp]V+
    op_e$<$~3WT]]sz?z[5J*p?Am;$]#KRTUBsk[;-TZ-UWo#p@_^x[[isYl}iaeZVzZX<;uVflhkoo
    {lpTK7!K;$e^mDeA!a}p5(kU~BH$BOL'[kufOtTeGo'p7s"~I#oIn5#aT1sw]Ta:4r*X~vAIT|,2
    )XOo]pspxAVCzo@n{\z#,YQ{WK<E25$H5(a=~ufqO@@A%+YA{@H5oQH\C7jUY_+z@T7>B&"awlDT
    =7IINIEe~sO'VIDnDaRs-4#1+[@]Q<z3Y>^C3<wwQ=;>Wa\\$TlZp?]u^uH$9}$7]a}l;A$kod-H
    [5*mA{@-p2Ckz[7<Um!\,KaBR<uvQYW'W=vR#DjZ!\$>[[Ek>2PV]*~OZ-~iX,^'Ju]^/~Ts22YH
    $waU{n$'Z]AmTaV^r==*I][B~Q^m{W<ujF^WJ>IT{Ik$x,mY<^=;+UUri}R-IT}nGQB.H7j"KBEE
    wGB,
`endprotected


   reg				VERIF_trig_read_byte;
   reg				VERIF_trig_write_byte0;
   reg				VERIF_trig_write_byte1;
   
   reg [memad_width-1:0]	VERIF_read_address;
   reg [memad_width-1:0]	VERIF_write_address0;
   reg [memad_width-1:0]	VERIF_write_address1;
   
   reg [7:0]			VERIF_read_value;
   reg [7:0]			VERIF_write_value0;
   reg [7:0]			VERIF_write_value1;
   
   integer		i;

   parameter STOP_ON_ERROR = 0; 	// If set to 1, the model will halt on errors
   parameter sim_RFSH = 1; 		// 1 = model will simulate VL refresh pushout, 0 = no refresh pushout
   wire			rfsh_evnt;	// use this to monitor VL refresh pushout condition
   wire			HS_evnt;	// use this to monitor HS status
   wire			DPD_evnt;	// use this to monitor DPD status

`protected
    MTI!##R1WM~pkv]X@wlZ2wvV_+{+Q'QUjHI}MR?xp="QH_WoB*Z8'~Z2xsilesv@@s7znXqE_xx*
    3+$$@=jNZ>1HkXz\Dkmj^CGBzVVJ[CiRb~Csn@Eu$II@X^{}Y9AT_}[#VEe"#H'~oH^HB=DU3<}3
    *RHoPWYrK}!3_-E\eURwGC=CH,M%]XT[-}vB|b#5z5\lO#fix7Eq%H1a$QKJu5'~gEH~oy^nl;KT
    l>!nA~zl*!Xx@#}pa!e}>Z3<}KK}kv"q1G-Ze>wjws+Cz7<@\sV2@AC:*@L}?23ms[oE7rJs>DC;
    -[BRA{]3-13Hj>T$o>k.PS=?*O@]_}21@#Bb#C+W2}uzzB-~I>7[@aKHrZ^Riw-x#$mozV'k|{nc
    A5nCEhw^EUv~Txa7=r1BlO^'Z+},WQ?L$e}mIYXu{t@DJm$upY_r\VV]H[|wEu~^2KW'UZ>zOn=H
    A2]V-;=ezHz'=1Vs~2D7Z7-XBT\IJZ$';r(^@'=3-QENrWlwLDG7Z**Y]vkp'XT3D,plo[v#r@X1
    Ho&I^+w\?W2?HV7>l<mE?vZ:LwrKo1;[~:@1$5uE\jGwY<DV<OLKa-7o7TR?G}9Ba]pK$H_QZ+Ky
    w1\![X,']K+5GQ@]XY5n#H*Y=WT<e-uJsnsroWu-=x5WpxJW@s'OG,\u'W-oB7U_)>lZ3uAG'mOH
    D^}+KJE7_jB#;o3l!!vkHluUE}l=3=;O*jQ{GV#{!V~B?Gr[^hpeV+7IXI\7=^A}<l)wI[O6oe;]
    r3D_vA_$WvxH,mVX1GomeaTKe:I#$D^OUJRzj<x<v*cQVV3\Vn*>X@AU-!>[*<+'~suzl'={wHA5
    7U[1jz?bIm5a.HpO}*5He~wn]~o_2,X'pKCzXzI_p5?R}\*>XY?!#OB=HLwA3{wx!\Yq(~zz*',a
    o~[pK~Ys^GU'if=?u_$_HuCW}oo;akTr~vnXm[oCe,s-sorT2!{wZ[3-=~2Yjx]s,X<7ruX_5;>*
    ~n\1{2>w3ADrj<7!G_KaxWB1X7<\1--1+!9&nAB$!B'nuaARa5HAIEWU[Y#O_^!w^5ji=]^QD"Dr
    >~$ZAm$Q,ICmAk_;\T;\GUGi~D}}aWC;Jne@RT|c!Y!7W7k[I_l1.BmDJ'u3wTT^Qu>;e\,Qx>s-
    '|<_@Z!\xuQ1v{{[Ja6,i;;$wIT!sQ2TBXuHU+Xm}E3]Ox2z+lUI*!ZWR+}Xlm?s^G{]#7;uXDuZ
    XnX*lXW*@v\&[?2XE7AA7a;~UXRi[2QI2vi!~Rj[Xw<vly@D,5-{;?oA*kyr_+,mD3~?TB]3nOA+
    LQCXZMQ37{-Tprcp#Ir<]j#iQAV}rC[R{AoB@D~,R]7W*i^uB#^[QsD}7alX}$~~<j*]-^\eXW5T
    pzY\,W-={Y_m1Jz>jZvxpO{7aB?~j#UG%gyEZ_n~O]@_x>>mep+jp[uE;r79lWBEH}<3$u<^1Rpi
    NUs+rv<'~6IDieJV~JVV]CQ{1<}_C5_0{'3HuXZxso?[g,{x\wVD-*Q>A%7VC$Z*Z=Im1H@]=wQ#
    nQ[<D2--}n]piuoW1K}xGB!1A$r]+2VE?$?}v=H$On5TmC[;O?['Oir]x}\meU_D',,!+C'7*1;=
    #psz}{>L!<WDxR'{oCuJ27VHnTxX5G?@R*H\1Em{kUU>Iu_pcKrvO<=p,Lsj2#W<2;]BCUlU{GGe
    w}rGCI,C!3w>[lPze[[KHjJA]AGzN@E$lRw{'Z7'eN^G![/DB#*^Wn#I)(iH+s'o#]aX;@T,lA5i
    ;[PQO<Kl3[uE_D;xsuCRpwB'"0YARiA1riX-0ECQ<Y@$IM*zw[]_}Qk<G@o|$!_3sw]e!]']$Csl
    s>\R']Q$&X<2$ioY]T*}V<<{]};,ojr_=A{Z;<v$^B?T'*Rk=[~T_m<2T?zv_?_o37lm{HYJJ=7n
    *F|6(Rp}Z/-<o'v3IB9T]epb5W1^2wweQ!+-q:(TOxK>5{l^p\As!@UT$i^%#7Zus!wu7BkJkUDH
    jQ,51i~O~T1axk!Y)ZBT-}x]~G@a{?A7!2CYUW^H*=W>XKT-vl}wvzv_W92CN}Ga5B;JVn_nBe-Y
    e^#s{{wQx_*KR$Eua!ODe}o7\,_HCCi;[_?,5,y57r3fn-'vS6#=z1]Q}ixkv#~la_pHuRw]-nvj
    im&?*ZloWA<RC>lOBv[\GBDpA\pr]\n|,2C'BG*>Bkl*iT!@\ok7Z<!1XG!C[__}lRil[;u<_ro>
    taO1;aGmH1jppHR{1D=\G>pn*h]<1s\B$iRk[11juo$U[[rT{]K-u~>_G-uAZu<{$7Cm{^Y=3DiY
    YB}jpssZ]e*?Tu=32OJ[!ZIR#uQ+qGWuUu,BWeJ>$8jaO~o_1Aei]G0ou$[GB<R'Tn[]mDnN\;XX
    }O1zxExaaX\#p<Q\HUE,$E}>1mD^Mpu!AmE+KK\*o#e,{Ojo$Ri>o+pIlTnax~vA$]VzERKlo2o1
    ~OHl5j>s*Vkn+%^'iz{121B[eO6~QB=[QaW[>H{c|E\TD!8dmlxWt$mA}}*_kw}HExRTTJCklp>6
    _To>lVWIs$?^]z?]anxzwO*G-CVl**YpH''-QZ!w1Z3n~H$XDrZ=Xn7;0^jl,>7CO}B*$72eY/Dz
    V-'Dj?xsG!2Rj?\iUO=#R[fkHu?!ITOtGijjo!YowY?_o;w;*OempI-ui=5>*OkY1Yj;guz#}_r?
    rqGvV{;EU\&*!OxE_\Q=EQ=Im7|=\[1vJ[GX*XZ;jGnv+YOP^Ia~Ll{*zt<AHv>rB]Bvu*mpB25G
    nn7ov$-5$Uv7$x>,ma]{HK_@7@:&hEq?CsH+Y^?Ap%lYwo}Uv7Ae<_G-}#JA27oli#n5Ik}p1nOj
    Y+j]Y,'YXVQQIKTz>}Kle$Ripl'[3GmU!_^Z3$}-T7}@1~>+OKzV>+EwK?YsITn,;j^X>Ke]+spe
    >^Anl{lBsGW(5nx>3[1!*j^KQe$!1U]A1uI{~vbH{>{V2W+\ir^CRKCG*RXaz,[knnk[H{u^Injz
    eZ5OsYDB3Q}5sOB^5+Jpnlj$v[zo;ZJulCE^*JJxTn]D~{YenokHE=\9ke[A$\~G[z?G?nzp_B-O
    C]nsEl+^=}7$3r|1?Z1,i]iO=xsD!D1}eU'$~lC?GEGvzA@*]21Qnr~I;uG/rJ@IT53!;X}BIT^<
    '%3+~TBVtDo=BW7T'^(@},K:5ZC_=Vo*nB-oW5oYp^IGps'[?Cw!E3'iWU7~[ZC<.RBa#i\$!#Q=
    Hi=W^oT\ncmRJuTXD]*2$C<1B$\E?xVxlXDa\nW1CBCA1!BUuwe+A]7;!#KTYlKr!']*@uU=@*Va
    1a*Gn3)]<s};_$ACW|,3mJs'ir+Bd-_mT=2Qk~}=x>XBDhWT3~Ieu7IeJD}6"~U_i7Gz~o_epU*1
    @LHVk;we_v!O;=POq\1A3*}1-8zx+Ou,{euRoQ5j@2,_^2YQx[YJ@ru[*;@*Xz%HHOx-A,,_~WrJ
    [@'!pOxs#;#[}{QbaQKGxuTK0D>9Gu_wZQ,'7'+7XB>^r'xm?R-XbXr3Ojo3VCA-x7!=v]XU*}qA
    }nT]wH2'zkj2Nol#w<DB_enB-DwO[ixC,7xnUp.Eg-+D'8(XwK;f'RZDJH-[5_'oKGRHi[55&<]>
    3CTElRG!s~5TT!T^p'-![JIRHpBnsGRumXz@YJ]DBAeI$ol7uyVE~;'eY@[;$]eUHWl,>p;7xUIO
    D3Lsz?l'_vvsGjsaE1^*o>^XT3@GOC_[OI1TR>2<I~<j*!DmTUG'A1KdZ1C@lR,7<_eW=]V5U*X1
    >axm_#Z{-nIODeiU,=rp"n><5T}~UVA$\#_]1jqJ>Z2-<2x~plY>{BHl^\?xsuYJ+xecs@C?;azD
    nI~2Kpi,Y#T*_r}2sQrV$J~eJlW_W\#TMQZG@8m,@Q#EOGCpm!;DQw-_Z'Qsw2lBTD#+u#xKEYTo
    {a#w5EpivJF0{T7v^:}W>I5\R@d\?;^;7EX#+mu5;r-B*!\rCVZ'UxGl{\ZwX|$+*T,DKGI^l!s?
    '}#'<ow{7s8GTH#!XZ?<5[ode~_]o>Go[p'G^KA$UroiGx;EC!_@,$'2,w^p7#=Wo3{5C!uO>[ZO
    m{+e,rpBoT1[bp7?}}G~3g[n-]rHTwrorYe]=G^i55}>A=BK22Y^]-l_{Vzu@JF<,{B_XAvfo]j!
    U{{]pr2C{\sG]H;\V\@j2^J{?I\5UOE;_NFE7UB#sx$Iy;RvXQlQ_$ElUX\msE_kT$nR>nTQXjnQ
    C_pCvruvBqxklk|Em@oB_+a'n<oD_3U=jT~HQ,]V3!AIaZ~X[ww}~YCG{V;Ce]3wR2oHCpnuQR'u
    5~@ajQa9*?nYv~oYplBIUlaG|>w{RKzv?Qp-21]]U?OCwg?>AZRn3a?n>2a}jV^r@vp*#Tw+uv7<
    [n*k_XkAO7f}2<k7u_Tml~l9o>\!}*zC?-U'^G}1Q@3!3zf^$RHOZ=jWU^<5VaUtU{W{!As'3xH2
    C}1[2nr3?^Kz~{X!zU{e{U1u1mGE}+Y-G=k31<=uBaEnIR+zLwps#RZe<4wCvJJCG<g7D1v$Z$;C
    '[Y^dr^R-'GABBrWY@-Uo{[sWjYr@[#2-!jJEEAEzNETIs|W<D2DW$YR7][^n~\)r-5^=l}=I$Ao
    ;1o$V^i}WIsiB@*ZOAQ$-jx^Kei!:^#V~}Dn]SADGWwC3YCYm?3T!,nXE#']'}jz]3nwnp^?+-ew
    wHktBWxHEHsx[72uEDo5Ma{*H_+~ROI^XhzkKRV]_~p+$[\{HVx#;G,GVp#]Z^~7<aU==W(|m{]T
    ^DIRmE^VKRxm:a+SmTTH0~}QV5aTrS,}O2ipZ=}Vo;5?\[eJ!'Ru~2XDu5.X8,z}}TGl<ax!u={-
    z2]I1"v3CY{l?<Qe!k%@jQH]wwV&:z3wub3O=<k\{Kn}]?5EGiRU1*rA7R[X5zmvUH}ZRO3nl\eC
    ~nwVroBmnAlkJ+x7YZgyvZnOiD!_ys5*Z[C3=6Q2^~\u\X0e>@\i>TXr!EI*z+BQ;r,rWppN|X]{
    '[K[!+A^[3=zEIJ}#SJ>lu}Vlmj>,mIhJaw{BDB,*B2^]zKCCKmn{}I27PIsD-v~aD{-=jMVAXv\
    OR+'px+7*r!x5B\RYZpuO_OP~I}BmAK3n5@,zaHnoK;,_w1vj![l'vRaO7o!#5BI8ae1G\}}Q%pj
    w}g;j#V$v-r?nGkYB=uZe1wrT;Q?+5k]k'KwGIICis_$YkUrB?+9pvjnTp_EH\BHcw1Ol}Zsz\B-
    -1p$a!]C<h<r,Ta*CYxzu;perQ;Q1I'}+AfUwJ$|Y_X2*Q-7AnUTww~Ks@X+l~B-cU,?^yv<HBrn
    +7PpAWo1Ypm2z13O[Q{?UCDi1Hu}T;<f#jiJOm,+<eiJ~vs1Y3G2<}U+m*Z*PW]ei7_n1T\BwZUD
    ,OBHu(i5Orz+R~Y#@pY@I!C@2v~UliUDHA(Vz+]_#!'|KV>W$)9NiU^{JD+IZ'DX[xi23CUpY\k{
    zL=C@o7*sm+YwO'g(5}i}d}s~EvD]m{ri-5KDOW]Vx@\EnY-o>V_EW-p5Gw5{*r[>'m-IaKeHmU1
    j3C1G}Q0CA,,}2KYGYJU-UJCXe$ekw\ZGQ{}{H\!$CHzwe?z3okk+wooLj]BVQBU2r!jGaVCIBHn
    V(*"r3oe1r+RG5J-^~QsDnl,*x!Bv_EQ)Y2![OZu?[0YGTa\JW[<_z'VT*k_-B<OKVz}wGr@}2rp
    Tu#KIkmc]e'B7<nxx]aj@H-~#jH_'KB53e$!\j27[Zv'zD2EVZ~{!AW@A>wQ$+_-^C@}\uxi}UsU
    _=+~*<Q7RED)uYzl\='i7>+mg2+EnKjlY]#^^aG{T7Jvp@=#{Xvx>ITO?b3*lpe|ek]uYmTBsx~l
    _,iw^Ik?o22<7,x[|D!U>+,E*sC!3]-Cs&VZ^>KnuKD*]k{om}K+=I(ZrA@3^lDKQQzBjD7~Er3=
    vkO;',B~\Ij<<5+VOOUxa{#uo>voR~]i>Gw$orE*.dpn2AOsmKuVepI'eHXD-*hh7-Y*lapzZeow
    BkHj{OU_gEo1#}iBRn.=iZwP_XZRQ^Am-R<;=d$Q<W~XAsB=z=VH_l*+2+~Ya'LaxY,FUUBK>j#^
    5{][gaE@<Oz#K5*lAG_#>'o?z.0'h_CO7q_!I_?e[OR>pl?Qxn^?Aph?B^5:{+,v9QDHlOo+T1xo
    oj{,Js;\s_Uwr"=sT1_JDB>=,}roriM\HVDv}+VjnWUdlX[IcrUuoUXrY,<HKNp{^Ro57knG#r-z
    Pl2'lDAWK1;V#'K<<EX1,qk>_al<!KNun5W~Ouv\<VajW;5=$+E+}H@?{!7G^v}'vxW6-LUU_r\J
    }KURn\Xn<E=]oT3Yu7[@OIG0F*=E=v_WIa>[l,'>?!HoGpJ7w<}pl-oaa'uUrO#1ij#A@p}_!=\K
    rWQJV$TJK2*?[>xpkk\^E}?C2U+jeOVCZ[~\j$]R-Qz#b+pJD]RvT>1E;w^&*Xap2}\i}rXGl~5u
    |TTQT75^XRR,H,pWjf#a,l2=pm=j]-]B}?F~-sTYxH2Qw,X>>@^OR;E+U_EADiT_GB!3R$=GenY{
    +Uo*E[n7BT~o*EuQk]JmAe3GJVojr#-Eke!j,7QwwUZ2CETX>$v7&@n{DH1iC)?$Bia+Ex!U5KsZ
    HE$OVpYT2<o?GWr#He)~$pG*p2!Iw<!^>W?aaQVc!QGW\\K?LrBA$%Vo25pjJ?=wJ?@<O;1Rl^g+
    5!>WN$'{Qc\{^On&OTBQ*DT<-jDxBuDwl{TUn-De1w]A~-][m=DiV-w{JRu{GYAvnIwJ,#+@zj][
    E'2'w[YjM&BrXX_R3*vx$]1XR>7aOQ!'2u\[oAA_i10klOK}]k5n<0I27j=T'~$CeOEZRu*RuIv=
    7WH5lX9,=X;nBnZ!j5uB!>[+A__XT,1a[wpjKxuo5'x#CvDl*Z72Y=e7xnalkAKXBpDzAEZ!^^vo
    PXsjTQBIA=$_H's2pEa*Uy(}-aoN;om''mT2W{2}]5iw4=BD}wH]@BQ=eH\_OQ*wz5;R1;Xa#L!D
    pGF*C{7#Q?[2oZl^ra3L}Kan[KaV'xDe$U5=^ZXowYZUbLAXxYRkI3JXKnX[,[R[~J1WxXl1G<=l
    H[1HsQj37-zfrKZDln-[lUI=pDOeC33~H_mxD@_U1p_-p@-[u'<XxaIUGwrX71>VaTwrYQOB+-+u
    e-z\;-3@w_=U3]Q@^m*+BRvX_'exlmQ{Do$D<<m2!psl_\2rz+Z]QUJHJXY]~-<^piwZoB-,;=}n
    9j~GZ]oQF<po7E-ZK1Bl5)$$<$\]?TNEjEjPT'A,;><~xCXHw\=*rK{QQ!eA?TEkk*m'oa{Ah\Av
    -7_'ExG,EI~CBV$C31lWTd7RR_g1#!F$^>TXTpmyJ+lWdC\}x}l}E{<BRcU7B7^Yz@ka3rF!+a#'
    O]YK=<_\VjZ-'_ls2(~5X2zlx+r}QYBYY7y"C]ja6!wG{#nUW*DEk-RYOK-_W,o?nj><xn{=7IV#
    ^"]W_*pav>K7
`endprotected


// *******************************************************************************************************
// **   DEBUG LOGIC                                                                                     **
// *******************************************************************************************************
// -------------------------------------------------------------------------------------------------------
//      2.01:  Memory Data Bytes
// -------------------------------------------------------------------------------------------------------

   wire [07:00] MemoryByte000 = MemoryBlock[0000];
   wire [07:00] MemoryByte001 = MemoryBlock[0001];
   wire [07:00] MemoryByte002 = MemoryBlock[0002];
   wire [07:00] MemoryByte003 = MemoryBlock[0003];
   wire [07:00] MemoryByte004 = MemoryBlock[0004];
   wire [07:00] MemoryByte005 = MemoryBlock[0005];
   wire [07:00] MemoryByte006 = MemoryBlock[0006];
   wire [07:00] MemoryByte007 = MemoryBlock[0007];
   wire [07:00] MemoryByte008 = MemoryBlock[0008];
   wire [07:00] MemoryByte009 = MemoryBlock[0009];
   wire [07:00] MemoryByte00A = MemoryBlock[0010];
   wire [07:00] MemoryByte00B = MemoryBlock[0011];
   wire [07:00] MemoryByte00C = MemoryBlock[0012];
   wire [07:00] MemoryByte00D = MemoryBlock[0013];
   wire [07:00] MemoryByte00E = MemoryBlock[0014];
   wire [07:00] MemoryByte00F = MemoryBlock[0015];

   wire [07:00] MemoryByte3F0 = MemoryBlock[1008];
   wire [07:00] MemoryByte3F1 = MemoryBlock[1009];
   wire [07:00] MemoryByte3F2 = MemoryBlock[1010];
   wire [07:00] MemoryByte3F3 = MemoryBlock[1011];
   wire [07:00] MemoryByte3F4 = MemoryBlock[1012];
   wire [07:00] MemoryByte3F5 = MemoryBlock[1013];
   wire [07:00] MemoryByte3F6 = MemoryBlock[1014];
   wire [07:00] MemoryByte3F7 = MemoryBlock[1015];
   wire [07:00] MemoryByte3F8 = MemoryBlock[1016];
   wire [07:00] MemoryByte3F9 = MemoryBlock[1017];
   wire [07:00] MemoryByte3FA = MemoryBlock[1018];
   wire [07:00] MemoryByte3FB = MemoryBlock[1019];
   wire [07:00] MemoryByte3FC = MemoryBlock[1020];
   wire [07:00] MemoryByte3FD = MemoryBlock[1021];
   wire [07:00] MemoryByte3FE = MemoryBlock[1022];
   wire [07:00] MemoryByte3FF = MemoryBlock[1023];

`protected
    MTI!#l#;p[=-x'WW[O7YV]r=Twz7*v1sexnHQ|e;XU7ZY+/FAY*:'~Z3Ez*zp*!QZR*ATTw'WoVs
    v5!nka\~XrHzk>;sG,Or#rGC*2VH$~e;?,z'ZO~B?XK+Y>\IvtoKwEOTu?;<ouc__{Y}C~~{EECE
    T+$E+v]U{vQB~Q[*WQ_n$?rGU>;,p\DIZOX\UC73Tx}xVu2.E?2-7xUYTVkIGTO,jp5T;>@HA77=
    *C!T-aGHn[@k}UxD1}Q~x@msUE}~-}O_C1+1$C2Q<D#HnoZe'HAkLw,,xkaux>[X2B'J[]x?[p@O
    7TEIZ_o=>B<BTz>-Z'vOkE+~D\~DKa\$~E[Y]}vm<;rMY+a>'#QV&#V!'^0MB^HB[BkEB?V\=>wG
    =o^Wz?Xsuvf!NVK<\I>lUI,!aB^E!l^>_^\73K^@~<Ee*@<wuG?V<\{[o-Qi<cYWa!CxmxD122l1
    lCrvBJ|i\Z{t1Q+\\-pk|Ta2c]#\=2}lx%NVC\w=mD^1<@WG@-^8!O<B\EJ+\1BY,BE2xUmkm-'?
    &jj2ey><Zu,V=Wpwo<da|(^$~p}+7k^[[}anQC*>A~$UQ@A+1exa]+C\Yzwj;wCgl'WRs5v[*XJH
    ${_iRw5GzGlXf>wCv^+o^prJ\\zC7mQ$IRQ+nos[!Tj+k[ao$oCsV<Gm'o1_;r7<JC[<@e2QAlnR
    ^5!xZEKJrvH@X7^a5K73U!a{'|lZY>L[D{GxHH+oeo7s,!'v_pRTxia[Rk-T'}W}>XEXDT3wajir
    @TEUC}5!pKCr@AQj>G+=K\z2BT[V<R]x~~lL)@]X[SDGA#t@5RBmC2aao@})_j_7DWXl/TrE'opZ
    GOj[wLp#++uBoJ_!V1r-l^lHvs=KnKd[+*ZC>*u;^W!6E\x}5Zp@#]n2kz5_3+;<Hwe]Q~U{o};+
    ''@[=G?ln>vO+1p5,I@sN\j\{iXV=~[{\e!DrWr.}E!E7K+2_V+<?pelIm_eiO>U\@UlP<DkXYmE
    ?G}\>QZvDYUAC~a}7qIW]}aez^C2{!s}I$GQ{lE~}lN*$\]:{Xn5#-jp\dCwB7"?{QX[;YVYA;!k
    {5!V+Dkq>5@=>aD{n}j~'E;^QK*sk-=}m{<u7}l[f!Y7[:Aae7I<>s[Q[e#1:<V>^_=~$FHA[\"w
    G3D}GWB3eD7@$!$Yk'Ie_j,l,;GTV3^!>ITYn\O^zK>1l_zZB-E#avY=<moxAekY\*mKD+\l}5#A
    jTAQe1?'EX*GKY$S!VEBVb#CQ!@{l_WtI~-m^s^w1nO!,wa+ET7v5T;#*k.}?;ACa*aVrD$WBm-B
    x_{~w{KRr#'ln$<Izawv<DZ:W{YjHTp~Zhs>oji}mOG>2Kxpok2^vG$U--xDKJQAOTs3O,K'-pj]
    }sUwRA~+*#Ijwo[l>~5wXvyn51_2AIT_#nQI,w{'_rr!>,Q\1\WXeeVsT<H?>}-cA-\K[w5B<^T*
    V<C'^Al^C#{?a$lO1Z;^|Zp!wk{^}oDvpBs2na6I@X7=@\aE;e#K^XR_^R-$>{{WAp[};w,~B^nz
    Jn~C\}k,~-%tm,\2_1$rWD{nS^,Dv2\GB]>7j7~rA(%Q>@e|CZs<suAnhw'oCl_3YhQE\1<1,sE#
    '5Hslre*j'V~3=Z_u=0I-ZfH<53EmCDlD+T0!Y\>7HxVj>VIS5m=7p-!O$U+D,DC}4A$XW|QX{sJ
    >^z}iv_F$ji2Qw]e[BG$*J3@xa=*([-_*"[K!r**zU#'1D{$'u^e#rI\XoU1_kppD[ev7\kCz{\o
    \[dBQPBXEx=lOBh_"~6OLl,-k6I_*_4*jp7KjH!6[K}lmE77>XAx}H3-o-DKaYzR}DRV'>B}$;Wk
    \+X_e{C7Hj$ip_D]e^lv6l?l[QwCH<G!?e\-E]EEknxxwu},Y'>vJDrDE;5<s'VY~5vWB$[H#vZ\
    7,,>$vTxC|D;_w=ZIG{<Z2VCE*vA~sLx@}OBmvJ{E$}vRWoK,RD<Rj3?x=#]TwXR1r5IP$m@?E,-
    ]@=+IBR{]vkR#osK?L?rl?rDsn_C;-#w_<ET\5]Zxn;\sWV,#~qh6#\B#,H2Uj{n2<lA-]on<-}U
    oYuX^X=va~Vs2~I1![BCH\voZYH'71e^-@*U@.8JnKx?z^3P=_5o,+wjM/o(]D@e7;Jv$B_nV<+k
    8{z=OEnno?l*z#+GBuj2-2*\\2le*WH\$Qo_~Cxj@K\mD=VU{pE>G'Xl5r-rJ2BxO9b5I|RD[,>[
    j{XzAV>eGQWE+R*@5x$5Q]cHCE!xWCvA$v'Z[msGGCO/#+u<D[{TY@rn,A'r3^oz5#<ZB#YOOm<j
    VD1G#Q[Ur<<VVJRxpdQY,{O]2WY=![9{H$lp#5\,qHG_rZ'\lE!ICE-\HpkB!Q[*K@9Knoj'sn,=
    31Ro^7KCiWG^QWl@AAsV$<p1vv}A{hxw^@cvX$CN^?5m?,~}aY@YB2]xe\I{or^HBW[$Zt[!Oo1Z
    TJ4mpD?-O*oj+x?omz7GwBWxk$x?onkEhoWp27OBY;$o,P-&^'R<tUIVEzuO1/Gl\{WX[1vWwj+1
    _wAl7kC{+7I-JuXo*<R;\<6EGW]p;O[wwZ5}zuKnxeo>{UQk{\Vz[>QX'$#[k[^kaYn3rYW\Wj<,
    ~,lwns*}DO]p=l~+[#HEA-@>a7~?[$[=_o1O,]wQ8+1RxLPJ6pC7\<C$?KQQuPTIKB'-VEB_lO+_
    #Q^QD^@G>vkhze\EGVXA>hx~IYkQ6!lEZl^ZoRE+7GsE$u+HTmva1\7@k_Z$?%B}]nDX!}k5AC,6
    ,5O>WO@G=[i'qG*<W<_,#WaIRZ72Jx^u!.{sBThCA[x\Ux5u]n3PUC@5U5G2]1Q;7kHnYn$~]Y3m
    kO?7sn+_X1Q,:l~v3K{ln_O!lm,Tlq,P9BJw7e#H\'Qxa_^_[a\ExQ!jj>,,?7_mk^^#D*0.$_O$
    3{\x-aY[v||l}UKZ^H{
`endprotected


   task memory_write;
   	input  [row_width-1:0] row;
        input  [col_width-1:0] col;
        input  [7:0] data;
        reg    [memad_width-1:0] addr;
   	begin
		addr = {row, col};
		MemoryBlock[addr[memad_width-1:00]] = data[7:0];
	end
   endtask
   
   task memory_read;
   	input  [row_width-1:0] row;
        input  [col_width-1:0] col;
        reg    [memad_width-1:0] addr;
	begin
		addr = {row, col};
	  fork
		VERIF_read_address = addr[memad_width-1:00];
		VERIF_read_value = MemoryBlock[addr[memad_width-1:00]];
		VERIF_trig_read_byte = #(0.01) ~VERIF_trig_read_byte;
		#(0.1);
	  join
	end
   endtask

   task memory_clear;
	begin
		for(i=0; i<memad_size-1;i=i+1) MemoryBlock[i]=8'bx;	// junk data
	end
   endtask
   
   task memory_is_addr;
	begin
		for(i=0; i<memad_size-1;i=i+1) MemoryBlock[i]=i;	// data=address
	end
   endtask
   
   task memory_high;
	begin
		for(i=0; i<memad_size-1;i=i+1) MemoryBlock[i]=8'hff;	// all high
	end
   endtask   

   task memory_low;
	begin
		for(i=0; i<memad_size-1;i=i+1) MemoryBlock[i]=8'b0;	// all low
	end
   endtask   

`protected
    MTI!#t5;@X';pkf*->+4%K]i@=T=5RzO__CQ[MBzF7k,5=~HQN.AQ?WC1g1>RTZ,OKe33w_?{3lx
    u=CtlZ{X~5w{HzG=isr^,-15GUQzV^OK_*X]zI5~{5_js7<H}~p3Z5l1X<C[Ikuu|sDn#/,F+-Px
    3\JjE\UO}pBVlzEBQ[s^[i>>HeBr[<;Y7X\j@.G?>_S_tAsk<;{voYU{X'l[xDmjz3jk+2>r~0,>
    \^qQZ$\0)s!Bop[^vB{vJe?<\;1s7[lz11w$--xlE}@3BH_E#=_Hs1B*lDF61Y,~J_Z\IG7~=$DG
    -V3l1!C5e#xHd'ru{EY-xr$CoAV[Ba'*>A{$G9UD#lU[n]E^[-e@Y][#>Gx{G~Qa'eK_aR2D=OBH
    r1K]l~<A<{BvU=uaB{c\1GC{+3^[JB\KO!E^x!mIB=ZoETSkaE1v2,E7+{r~Q7vr2TJBT]T@$2_?
    -_3p#5nCxmU?^<paY?3Bj3\?,A?2'u}'A{m|K]z+J-Qj{I^u@]=Wo?<<a|}HpD13p_v+1_CU!a1#
    o#uB^@k+A]p/$*ArkB,xm'#+,ku<C?!3!aXG=J}2KYDmi{T*i^=Er$aX1Z[e^[\O'-1Rj?ZJ=$~-
    _2lYwjZQqD^Un}?DUXD[pluH*o-UJK<>XUU!oa&YDQ@52_GuEx5}?Yw4BJK}+<ZTDTm_oaH_o~XZ
    GCv58p[mKx>^;$z$Ii'J-Cj;E0[Y2p_s]@E+v}7#1~S!_xe]pEKs[A^'@!vkIW_^~j5EuesU=Qjw
    r*vp5_GgksX],]kmIYQi9M[x-X~n!<Fbf1XIQy1J+#bAEz5p'MR!x77#@sGT2u/,WIn]*?^i=I#[
    K;oJD?#s-R#eIGw*1IRTDi<uoB^px$o=K$jee5R$$WDGu+Ka[;?Vinl-[Z2_ZD~'GeW'eiE@N)8%
    ^pj@08je$m#nsIG[I#DTGD5-]Ws12v@*XzqEXr<Kpm;|YcoU_,a5i!Ts+H^@O,RTZ@xazWo^K3w[
    DZ3pKYj!r2dVE{#.Cs<O8Ht$1%c=w<137[u?_AOOCzHp;o^?QUR-'s#nTe{*K7-/<}?sO;~QROBI
    '7IGe@'[?a<<.{+W[]H~kW,$7(/eaAp3ERHq[nQO#-=[[u,#TlG]*Z]!*w=Ea<v{CMEIGl{RAe{e
    1-7*{C=j*Y;ol@z}^bA5J]kH5-eXr]K$BoUHnZJV,7wa,3gaO^z%1pn^CJtIzno|^rl3B\]3I~om
    HE\j*HKoem<{Nl@{^oAn\AlK3PC'[rrwm]=<b+o='=v{~h67>O\YOV}Urr}zE??}j*@sVm''GY29
    lY;!1m=eoOk'RuH![jY]+1>#[!<ABYpY}\Q?tHr?*+l@}BC$7lJ2oo>^+YVR>Tpsrh>DZJz'2'A$
    >mVu$Zmr}kl^\a5}$*=m,3G;[7X$kKrv!k}{pQ}V3jPkzK<._+DiGC7}1]2!=w~wI+3+RreCHrVr
    lQUQ2oY@pK[[#-,@$kHB^AB,F+wDk2D-HiqK{nlSE#{VQ}k]2Ra@iA@p+juuopz*4mp;1@jv^y$~
    sk&%vFrw7_r*3xBaYjTV^uY?T+=uIE'DR[$3wED^1^c5%oWCvY?\\CDp+}nKY$we@(F!Hs7sIZI5
    DrV>+_K[jn+eZ{;B}nk@x?rTnH3yA6^S#laG]@*i]V\}p_;_@OwD2SO<JW$wR2Z_uRkI$@B!_TYm
    xiurk]88HH1T[Q~3nX'[CJv<cH7KZ]w7\_*sEJYm{j+UjfRe8|4YE\#h5!OGr>jiwj[[en-3%<[<
    7,ZQDvi;Z1>,;s/1lB}Z1s7OE'KVIoi}nmsI,RDMG3JH6aG-D~^B_-E~sDX*{usjJz[T'-1YRBe3
    @}[V7r!5oo^2@ao.[}VJ]#RplHQU7W!evrZ1e2;jno!E]j2!>riH$$UCwz=CRq!h[*5z|+QW'hiV
    ?-rOTJ},Z}T^BE^uwmlX5H1W8sT*7S}r;f!-V{!q%U[Z'0L=YI?Iuz-2-K=8$r#_B>T^1+^w^%jv
    $2n+GTo%B-1;m[;WB?nBL[eEU5]aonnD3]!Ko0H_<VC[C=v_#ezk73aC<,>E2w|-xHmk*<~;[!K]
    Rl5IWTnU'{CTv@vOrG;\wY_W^2,mVYo},V}\\lewUpZCDlB5{Bi!pC#GsII*;r<{D1rA+azS~}kT
    r,-a-<]<v,H5|I]spQ3v!]B{7'K7VKV11U,*1%{[Wq2a-E}#!riCgzavHG7CV-jnJ]gB~H+1MlE-
    v2D,~~]X@k>A#X^C1<7Bl?spJo$buxl5hJ$C;'pr1VQlw1Y]DpizTY%K5=un7WrVw>zruzYzAs{Q
    k]I?vBi^Q~]sp}i'?-HoDH,A7
`endprotected


   specify
         specparam
            tSP    =  0.8,                                  // Input setup time
            tHD    =  0.8,                                  // Input hold time
	    tDS    =  0.8,
	    tDH    =  0.8,
	    tCSP   =  2,
	    tCSP2  =  1.5,
	    tCHD   =  2;

      $setuphold(xCLK, xDQ &&& TimingCheckAddrEnable, tSP, tHD);
      
      $setup (negedge xCEn, posedge xCLK, tCSP);
      $setup (posedge xCEn, posedge xCLK, tCSP2);
      $hold (negedge xCLK, posedge xCEn, tCHD);
      
      $setuphold(xCLK, xDQ &&& TimingCheckDataEnable, tDS, tDH);
      $setuphold(xCLK, xDQSDM &&& TimingCheckDMEnable, tDS, tDH);
      
  endspecify

endmodule
