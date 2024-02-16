import requests
from lxml import etree
import os
import time
import xlsxwriter as xw
import re
import pandas as pd




base_url = 'http://search.cnki.com.cn/Search/ListResult'
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101 Firefox/93.0',
    # 'Content-Type': 'application/x-www-form-urlencoded',
    # 'Content-Length': '463'
}


def get_page_text(url, headers, search_word, page_num):
    data = {
        'searchType': ' MulityTermsSearch',
        'ArticleType': '',
        'ReSearch': '',
        'ParamIsNullOrEmpty': ' false',
        'Islegal': ' false',
        'Content': search_word,
        'Theme': '',
        'Title': '',
        'KeyWd': '',
        'Author': '',
        'SearchFund': '',
        'Originate': '',
        'Summary': '',
        'PublishTimeBegin': '',
        'PublishTimeEnd': '',
        'MapNumber': '',
        'Name': '',
        'Issn': '',
        'Cn': '',
        'Unit': '',
        'Public': '',
        'Boss': '',
        'FirstBoss': '',
        'Catalog': '',
        'Reference': '',
        'Speciality': '',
        'Type': '',
        'Subject': '',
        'SpecialityCode': '',
        'UnitCode': '',
        'Year': '',
        'AuthorFilter': '',
        'BossCode': '',
        'Fund': '',
        'Level': '',
        'Elite': '',
        'Organization': '',
        'Order': ' 1',
        'Page': str(page_num),
        'PageIndex': '',
        'ExcludeField': '',
        'ZtCode': '',
        'Smarts': '',
    }

    response = requests.post(url=url, headers=headers, data=data)
    page_text = response.text
    return page_text




def get_abstract(url):
    response = requests.get(url=url, headers=headers)
    page_text = response.text
    tree = etree.HTML(page_text)

    # 使用新提供的XPath定位摘要所在的元素
    abstract_elements = tree.xpath('//*[@id="content"]/div[2]/div[4]/text()')

    # 将摘要元素连接成一个字符串
    abstract = ''.join(abstract_elements).strip()

    # # 去除【摘要】和【作者单位】
    # abstract = abstract.replace('【摘要】：', '').split('【作者单位】：')[0].split('【学位授予单位】：')[0].split('【学位级别】：')[0].split('【学位授予年份】：')[0]
    # 去除多余空格和换行符
    abstract = abstract.strip()
    # # 去除冒号
    # abstract = abstract.strip('：')
    # 去除CR字符
    abstract = abstract.replace('_x000D_', '')

    return abstract






def list_to_str(my_list):
    my_str = "".join(my_list)
    return my_str


def parse_page_text(page_text):
    tree = etree.HTML(page_text)
    item_list = tree.xpath('//div[@class="list-item"]')
    page_info = []
    for item in item_list:
        # 标题
        title = list_to_str(item.xpath(
            './p[@class="tit clearfix"]/a[@class="left"]/@title'))
        # 链接
        link = 'https:' +\
            list_to_str(item.xpath(
                './p[@class="tit clearfix"]/a[@class="left"]/@href'))
        # 作者
        author = list_to_str(item.xpath(
            './p[@class="source"]/span[1]/@title'))
        # 导师
        mentor = list_to_str(item.xpath(
            './p[@class="source"]/span[2]/a[1]/text()'))
        # 出版日期
        date = list_to_str(item.xpath(
            './p[@class="source"]/span[last()-1]/text() | ./p[@class="source"]/a[2]/span[1]/text() '))
        # 关键词
        keywords = list_to_str(item.xpath(
            './div[@class="info"]/p[@class="info_left left"]/a[1]/@data-key'))
        # 摘要
        abstract = list_to_str(get_abstract(url=link))
        # 文献来源
        paper_source = list_to_str(item.xpath(
            './p[@class="source"]/span[last()-2]/text() | ./p[@class="source"]/a[1]/span[1]/text() '))
        # 文献类型
        paper_type = list_to_str(item.xpath(
            './p[@class="source"]/span[last()]/text()'))
        # 下载量
        download_times_element = item.xpath('./div[@class="info"]/p[@class="info_right right"]/span[@class="time1"]')[0]
        download_times = re.search(r'（(\d+)）', download_times_element.text).group(
            1) if download_times_element.text else '0'

        # 被引量
        refer_times_element = item.xpath('./div[@class="info"]/p[@class="info_right right"]/span[@class="time2"]')[0]
        refer_times = re.search(r'（(\d+)）', refer_times_element.text).group(1) if refer_times_element.text else '0'

        item_info = [i.strip() for i in [title, author, mentor,
                     paper_source, paper_type, date, keywords, abstract, download_times, refer_times, link]]
        page_info.append(item_info)
        # print(page_info)
    return page_info


def write_to_excel(workbook, info,  search_word):

    wb = workbook
    worksheet1 = wb.add_worksheet(search_word)  # 创建子表
    worksheet1.activate()  # 激活表

    title = ['title', 'author', 'mentor',
             'paper_source', 'paper_type', 'date', 'keywords', 'abstract', 'download_times', 'refer_times', 'link']  # 设置表头
    worksheet1.write_row('A1', title)  # 从A1单元格开始写入表头

    i = 2  # 从第二行开始写入数据
    for j in range(len(info)):
        insert_data = info[j]
        start_pos = 'A' + str(i)
        # print(insert_data)
        worksheet1.write_row(start_pos, insert_data)
        i += 1
    return True


if __name__ == '__main__':

    # 1、创建一个文件夹
    if not os.path.exists('D:/爬虫/paper_info'):
        os.mkdir('D:/爬虫/paper_info')
    file_name = 'D:/爬虫/paper_info/文献爬取4.xlsx'

    # 2、设置搜索词
    search_words = ['医保基金收支','医保基金监管','医保财务管理']  #[ '数字技术', '数字应用', '互联网商业模式', '现代信息系统']
    # 3、创建工作簿
    workbook = xw.Workbook(filename=file_name)

    # 4、获取每个搜索词的文献内容
    for search_word in search_words:
        infos = []
        # 每个搜索词搜索6-1=5页
        for page_num in range(1,16):
            try:
                print('搜索词：'+search_word+'---正在爬取第【'+str(page_num)+'】页...')
                page_text = get_page_text(url=base_url, headers=headers, search_word=search_word, page_num=page_num)
                page_info = parse_page_text(page_text=page_text)
                # 用+合并成一个列表，不是嵌套列表；用append，会形成嵌套列表
                infos += page_info
                time.sleep(5)
            except Exception as e:
                print('搜索词：'+search_word+'---第【'+str(page_num)+'】页爬取失败！',e)
                continue

        # 5、按照搜索词，依次写入工作簿
        write_to_excel(workbook, infos, search_word)
    # 6、关闭工作簿
    workbook.close()

    print(f'爬取完成!{file_name}')





print('开始文献评分======================================================================')
for name in search_words:
    desired_sheet_name = name
    df = pd.read_excel(file_name, sheet_name=desired_sheet_name)

    # 提取年份（假设年份信息在'date'列的前4位）
    df['year'] = df['date'].str[:4]

    # 计算分数
    df['score'] = 0.3 * df['refer_times'] + 0.7 * df['download_times']

    # 按年份分组并筛选每年排名前10%的文章
    result = df.groupby('year').apply(lambda x: x.nlargest(int(0.1 * len(x)), 'score')).reset_index(drop=True)

    # 选择输出的列
    result = result[['title', 'author', 'year', 'abstract', 'keywords','score','link']]

    # 创建一个新的ExcelWriter以保存结果
    with pd.ExcelWriter(file_name, engine='openpyxl', mode='a') as writer:
        try:
            writer.book.remove(writer.sheets[desired_sheet_name+'Top10PercentArticles'])
        except KeyError:
            pass  # 工作表不存在，无需删除
        result.to_excel(writer, sheet_name=desired_sheet_name+'Top10PercentArticles', index=False)

    print(f'处理完成并保存结果到{file_name}的Excel文件中。表名： {desired_sheet_name}Top10PercentArticles')




print('开始文献合并======================================================================')


# 读取'Top10PercentArticles'表格
for name in search_words:
    desired_sheet_name = name
    desired_sheet_name = desired_sheet_name+'Top10PercentArticles'
    df = pd.read_excel(file_name, sheet_name=desired_sheet_name)

    # 合并每一行的数据
    merged_data = df.apply(lambda row: f"{row['author']} {row['year']} {row['title']} {row['abstract']}", axis=1)

    # 将合并后的数据写入txt文件
    output_file = 'D:/爬虫/paper_info/'+name+'文献合并数据.txt'
    with open(output_file, 'w', encoding='utf-8') as file:
        file.write('\n'.join(merged_data))

    print(f'数据已成功写入txt文件。{output_file}')

