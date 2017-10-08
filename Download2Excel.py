#encoding=utf-8
import urllib2, re, xlwt
from sys import stdout

def get_info(num,worksheet,line):
    url  = 'http://yu-zhu.vicp.net/yzhsf01.aspx?yzhpage='+str(num)+'&yzhpageup=1'
    head = {
        'Host'           : 'yu-zhu.vicp.net',
        'User-Agent'     : 'Mozilla/5.0 (Windows,IE) Gecko/20100101Firefox/42.0',
        'Accept'         : 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3',
        'Accept-Encoding': 'gzip, deflate',
        'Referer'        : 'http://yu-zhu.vicp.net/',
        'Cookie'         : 'UserID=0; Userz101=; Userz103=; Userz105=0; Usermdb=yzhhdshw.mdb; yzhe200=2,3,8,; yzhe201=]; yzhe202=001; yzha205=2; yzhe203=; yzha212=; yzha213=; yzha206=; yzha207=Order By z201 Desc; yzha217=00000000; yzha208=4869',
        'Connection'     : 'keep-alive'
    }
    req   = urllib2.Request(url, headers=head)
    rep   = urllib2.urlopen(req)
    page  = rep.read()
    page  = page.decode("gbk").encode("utf-8")
    page  = re.sub('&nbsp;', '', page)
    now   = re.findall('第(.*?)/.*?页', page)
    total = re.findall('第.*?/(.*?)页', page)

    print(page)
    exit()

    col=0
    if num == 1:
        p1 = re.findall('<td bgColor=#\d+aadf >(.*?)</td>',page)
        for info in p1:
            worksheet.write(line, col, str(info))
            col = col + 1
        line = line + 1
        col  = 0

    p2 = re.findall('<td bgColor=#\d+aadf>(.*?)</td>',page)
    i  = 1
    for info in p2:
        info = re.sub('<A href="yzhaf0105\.aspx\?ID=.*?" target="_blank">','',info)
        info = re.sub('</A>','',info)
        worksheet.write(line, col, str(info))
        col  = col + 1
        if i % 19 == 0:
            line = line + 1
            col = 0
        i = i + 1
    workbook.save('Yangtze.xls')
    print "\r"+"Downloading : "+str(num),"Total : "+str(total[0]),
    stdout.flush()
    return [int(now[0]), int(total[0]), line]

def main():
    global workbook
    workbook  = xlwt.Workbook(encoding='utf-8')
    worksheet = workbook.add_sheet('Yangtze')
    num       = 1
    isend     = [0,0,0]
    while isend[0]<=isend[1]:
        isend = get_info(num,worksheet,isend[2])
        num   = num+1
    workbook.save('Yangtze.xls')

if __name__ == '__main__':
    main()