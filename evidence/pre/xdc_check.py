"""각 FPGA 프로젝트의 구현 최상위 포트와 XDC PACKAGE_PIN을 비교한다 (포트 폭, 빠진 포트, 핀 중복).
실행: python evidence/pre/xdc_check.py  (저장소 최상위에서)"""
import re
tops={'spi_rx':('spi_rx/src/spi_rx_top.v','spi_rx_top'),'spi_tx':('spi_tx/src/spi_tx_top.v','spi_tx_top')}
for p,(f,m) in tops.items():
    src=open('fpga/'+f,encoding='utf-8').read(); hdr=src[src.index('module '+m):]; hdr=hdr[:hdr.index(');')]
    hdr=re.sub(r'#\(.*?\)\s*\(','(',hdr,flags=re.S); hdr=re.sub(r'//.*','',hdr)
    ports={}
    for d,w,names in re.findall(r'(input|output|inout)\s+(?:wire|reg)?\s*(\[\d+:\d+\])?\s*([\w\s,]+?)(?=,\s*(?:input|output|inout)|\s*$)',hdr.split('(',1)[1]+' ',re.S):
        n=1 if not w else int(w[1:-1].split(':')[0])+1
        for x in names.split(','):
            if x.strip(): ports[x.strip()]=n
    pins=re.findall(r'PACKAGE_PIN (\w+)\s+\[get_ports \{?([\w\[\]]+)\}?\]',open(f'fpga/{p}/constraints/pins.xdc',encoding='utf-8').read())
    got={}
    for pin,port in pins: got.setdefault(port.split('[')[0],set()).add(port)
    names=[pp for pp,_ in pins]; dup=sorted({q for q in names if names.count(q)>1})
    bad=[k for k in ports if len(got.get(k,()))!=ports[k]]+[k for k in got if k not in ports]
    print(f'{p}: top {m}, port bits {sum(ports.values())}, pins {len(pins)}, mismatch {bad}, duplicate {dup}')
