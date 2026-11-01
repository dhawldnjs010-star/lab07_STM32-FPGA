# MCU SPI 마스터의 이론 파형 (Mode 0, MSB 먼저, SCK 781.25 kHz): 0x55와 0xA5. 측정값이 아니라 설정에서 계산한 그림이다.
import matplotlib; matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import font_manager as fm
fp='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'; fm.fontManager.addfont(fp)
plt.rcParams.update({'font.family':fm.FontProperties(fname=fp).get_name(),'font.size':6.5})
BLUE='#1f5f99'; GREY='#8b95a1'; INK='#1f2933'
T=1/781.25e3*1e6   # µs
fig,axs=plt.subplots(1,2,figsize=(8.4/2.54,1.9),dpi=300,sharey=True)
for ax,val in zip(axs,[0x55,0xA5]):
    bits=[(val>>(7-i))&1 for i in range(8)]
    t0=0.5*T; tend=t0+8*T+0.5*T
    # CS
    ax.plot([0,0.25*T,0.25*T,tend,tend,tend+0.5*T],[2.6,2.6,2.2,2.2,2.6,2.6],color=BLUE,lw=0.9)
    xs=[0,t0];ys=[1.2,1.2]
    for i in range(8):
        a=t0+i*T; xs+=[a,a,a+T/2,a+T/2,a+T]; ys+=[1.2,1.6,1.6,1.2,1.2]
    xs+=[tend+0.5*T]; ys+=[1.2]; ax.plot(xs,ys,color=BLUE,lw=0.9)
    xs=[0,0.25*T];ys=[0,0]
    edges=[0.25*T]+[t0+i*T+T/2 for i in range(0,7)]+[tend]
    for i in range(8):
        xs+=[edges[i],edges[i+1]]; ys+=[0.4*bits[i]]*2
        ax.text(t0+i*T,0.55,str(bits[i]),ha='center',fontsize=6,color=INK)
        ax.axvline(t0+i*T,color=GREY,lw=0.3,ls=(0,(2,2)))
    xs+=[tend,tend+0.5*T]; ys+=[0,0]; ax.plot(xs,ys,color=BLUE,lw=0.9)
    ax.set_title(f'0x{val:02X}',fontsize=7,color=INK)
    ax.set_yticks([0.2,1.4,2.4]); ax.set_yticklabels(['MOSI','SCK','CS'])
    ax.set_xlabel('시간 (µs)',fontsize=6); 
    for sp in ('top','right','left'): ax.spines[sp].set_visible(False)
    ax.tick_params(length=2,labelsize=5.8)
fig.tight_layout(pad=0.3); fig.savefig('fig/mcu_expected.png')
print('T us',T)
