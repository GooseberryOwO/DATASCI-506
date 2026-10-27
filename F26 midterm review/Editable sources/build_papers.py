from pathlib import Path
import json, html, re, shutil
from reportlab.pdfgen import canvas
from reportlab.platypus import (SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    Preformatted, PageBreak, KeepTogether, Flowable)
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_LEFT, TA_CENTER
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

ROOT=Path(__file__).resolve().parent.parent
DATA=json.loads((ROOT/'Editable sources/papers.json').read_text())
FONTDIR=Path('/System/Library/Fonts/Supplemental')
for name,file in [('Exam','Times New Roman.ttf'),('ExamBold','Times New Roman Bold.ttf'),
                  ('ExamItalic','Times New Roman Italic.ttf')]:
    pdfmetrics.registerFont(TTFont(name,str(FONTDIR/file)))
pdfmetrics.registerFontFamily('Exam',normal='Exam',bold='ExamBold',italic='ExamItalic',boldItalic='ExamBold')
W=468
CURRENT_KIND="Questions"
styles={
 'body':ParagraphStyle('body',fontName='Exam',fontSize=11.3,leading=14.4,spaceAfter=7),
 'small':ParagraphStyle('small',fontName='Exam',fontSize=9.2,leading=11.6,spaceAfter=6),
 'h1':ParagraphStyle('h1',fontName='ExamBold',fontSize=15,leading=19,spaceAfter=13,keepWithNext=True),
 'h2':ParagraphStyle('h2',fontName='ExamBold',fontSize=11.5,leading=15,spaceBefore=5,spaceAfter=6,keepWithNext=True),
 'title':ParagraphStyle('title',fontName='ExamBold',fontSize=21,leading=27,spaceAfter=24),
 'cell':ParagraphStyle('cell',fontName='Exam',fontSize=10,leading=12),
 'cellsmall':ParagraphStyle('cellsmall',fontName='Exam',fontSize=8.5,leading=10.8),
 'cellbold':ParagraphStyle('cellbold',fontName='ExamBold',fontSize=10,leading=12),
}

def para(s,style='body'):
    s=html.escape(str(s)).replace('\n','<br/>')
    digits=str.maketrans('₀₁₂₃₄₅₆₇₈₉','0123456789')
    s=re.sub('[₀₁₂₃₄₅₆₇₈₉]+',lambda m:'<sub>'+m.group().translate(digits)+'</sub>',s)
    return Paragraph(s,styles[style])

def code(s):
    maxn=max((len(x.expandtabs(2)) for x in s.splitlines()),default=1)
    size=min(9.3,W/(maxn*0.6))
    if size<7.8: raise ValueError(f'Code line too long ({maxn} chars): {s[:100]}')
    st=ParagraphStyle('code',fontName='Courier',fontSize=size,leading=size*1.29,
                      leftIndent=9,rightIndent=7,spaceBefore=3,spaceAfter=7,
                      borderPadding=7,backColor=colors.HexColor('#f5f5f5'))
    return Preformatted(s,st)

class Blank(Flowable):
    def __init__(self,height): super().__init__();self.width=W;self.height=height
    def draw(self): pass

def table(rows,widths=None,row_h=None,small=False):
    if widths is None: widths=[W/len(rows[0])]*len(rows[0])
    cells=[[para(c,'cellbold' if i==0 else ('cellsmall' if small else 'cell'))
            for c in row] for i,row in enumerate(rows)]
    t=Table(cells,colWidths=widths,rowHeights=row_h,repeatRows=1,hAlign='LEFT')
    t.setStyle(TableStyle([
        ('VALIGN',(0,0),(-1,-1),'TOP'),('TOPPADDING',(0,0),(-1,-1),4 if CURRENT_KIND=='Answers' else 6),
        ('BOTTOMPADDING',(0,0),(-1,-1),4 if CURRENT_KIND=='Answers' else 6),('LEFTPADDING',(0,0),(-1,-1),7),
        ('RIGHTPADDING',(0,0),(-1,-1),7),
        ('LINEBELOW',(0,0),(-1,0),0.65,colors.black),
        ('LINEBELOW',(0,-1),(-1,-1),0.45,colors.HexColor('#777777')),
    ]))
    return t

def regex_table(strings,patterns,answer=None,notes=None):
    labels=list('abcd')[:len(patterns)]
    rows=[['String']+labels]
    for i,s in enumerate(strings):
        vals=['' for _ in patterns] if answer is None else ['X' if v else '' for v in answer[i]]
        rows.append([s]+vals)
    widths=[220]+[(W-220)/len(patterns)]*len(patterns)
    t=table(rows,widths,row_h=[27]+[26]*len(strings),small=True)
    t.setStyle(TableStyle([('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#888888')),
                            ('ALIGN',(1,1),(-1,-1),'CENTER')]))
    return [code('\n'.join(f'{labels[i]}. "{p}"' for i,p in enumerate(patterns))),t]

def blocks_to_flow(blocks):
    out=[]
    for b in blocks:
        t=b['type']
        if t=='p':out.append(para(b['text'],b.get('style','body')))
        elif t=='h':out.append(para(b['text'],'h1'))
        elif t=='sub':out.append(para(b['text'],'h2'))
        elif t=='code':out.append(code(b['text']))
        elif t=='blank':out.append(Blank(b['height']))
        elif t=='space':out.append(Spacer(1,b['height']))
        elif t=='table':out.append(table(b['rows'],b.get('widths'),b.get('row_h'),b.get('small',False)))
        elif t=='regex':out.extend(regex_table(b['strings'],b['patterns'],b.get('answer')))
        elif t=='item':
            items=[para(b['label']+'. '+b.get('prompt',''),'h2')]
            if b.get('code'):items.append(code(b['code']))
            if b.get('text'):items.append(para(b['text']))
            out.append(KeepTogether(items))
            if b.get('qline'):out.append(para('q = __________________________________________________'))
            if b.get('blank'):out.append(Blank(b['blank']))
        else:raise ValueError(t)
    return out

def header_footer(year,kind):
    def draw(c,doc):
        c.saveState();c.setFont('Exam',9)
        c.setFillColor(colors.HexColor('#555555'))
        c.drawString(72,757,f'STATS 506 F{str(year)[-2:]} - {kind}')
        c.setFillColor(colors.black);c.setFont('Exam',10)
        c.drawCentredString(306,36,str(doc.page));c.restoreState()
    return draw

def cover(year):
    blocks=[{'type':'p','style':'title','text':f'Stats 506 F{str(year)[-2:]} Midterm'},
     {'type':'p','text':'Name: __________________________________________'},
     {'type':'p','text':'UMID: __________________________________________'},
     {'type':'space','height':14},
     {'type':'table','rows':[['Question','Out of','Score']]+[[str(i),'________','________'] for i in range(1,7)]+[['Total','________','________']],
       'widths':[90,110,100],'row_h':[25]*8},
     {'type':'space','height':20},
     {'type':'sub','text':'Instructions'},
     {'type':'p','text':'Complete every problem. Use pen or pencil; closed notes.'},
     {'type':'p','text':'Show intermediate work when possible. State any assumptions you make.'},
     {'type':'p','text':'Minor syntax mistakes are acceptable when the intended calculation is clear.'},
     {'type':'p','text':'Suggested practice time: 75 minutes, matching the F26 exam length.'},
     {'type':'space','height':12},
     {'type':'p','style':'small','text':'Practice reconstruction from the official posted solutions. All answers and computed outputs have been removed. Original point allocations were not available in that source, so the score table is left blank.'},
     {'type':'p','style':'small','text':DATA[str(year)]['source']},
    ]
    return blocks_to_flow(blocks)

def build_pdf(year,kind,pages,path):
    global CURRENT_KIND
    CURRENT_KIND=kind
    doc=SimpleDocTemplate(str(path),pagesize=(612,792),leftMargin=72,rightMargin=72,
         topMargin=72,bottomMargin=60,title=f'STATS 506 F{str(year)[-2:]} Midterm - {kind}',
         author='Practice compilation from Josh Errickson course materials')
    story=[]
    if kind=='Questions':story.extend(cover(year));story.append(PageBreak())
    else:
        story.append(para(f'Stats 506 F{str(year)[-2:]} - Answer Key','title'))
        story.append(para('Worked reference answers. Match the year and problem label before checking your work. Minor errata are clarified where relevant.','small'))
        story.append(para(DATA[str(year)]['source'],'small'))
    for i,page in enumerate(pages):
        if i>0:story.append(PageBreak())
        story.extend(blocks_to_flow(page))
    doc.build(story,onFirstPage=header_footer(year,kind),onLaterPages=header_footer(year,kind))

def md_blocks(pages,title):
    text=['# '+title,'']
    for page in pages:
        for b in page:
            t=b['type']
            if t=='p':text.extend([b['text'],''])
            elif t=='h':text.extend(['## '+b['text'],''])
            elif t=='sub':text.extend(['### '+b['text'],''])
            elif t=='code':text.extend(['```'+b.get('lang','r'),b['text'],'```',''])
            elif t=='blank':text.extend(['<!-- Answer space -->',''])
            elif t=='space':pass
            elif t=='item':
                text.extend(['### '+b['label']+'. '+b.get('prompt',''),''])
                if b.get('code'):text.extend(['```'+b.get('lang','r'),b['code'],'```',''])
                if b.get('text'):text.extend([b['text'],''])
                if b.get('qline'):text.extend(['q = ____________________',''])
            elif t=='table':
                rows=b['rows'];text.append('| '+' | '.join(str(c).replace('|','\\|').replace('\n','<br>') for c in rows[0])+' |')
                text.append('| '+' | '.join('---' for c in rows[0])+' |')
                for row in rows[1:]:text.append('| '+' | '.join(str(c).replace('|','\\|').replace('\n','<br>') for c in row)+' |')
                text.append('')
            elif t=='regex':
                text.extend(['```text','\n'.join(f'{chr(97+i)}. "{p}"' for i,p in enumerate(b['patterns'])),'```',''])
                labels=['String']+list('abcd')[:len(b['patterns'])]
                text.extend(['| '+' | '.join(labels)+' |','| '+' | '.join('---' for _ in labels)+' |'])
                for i,s in enumerate(b['strings']):
                    vals=['' for _ in b['patterns']] if b.get('answer') is None else [('X' if v else '') for v in b['answer'][i]]
                    text.append('| '+' | '.join([s]+vals)+' |')
                text.append('')
        text.extend(['---',''])
    return '\n'.join(text)

def main():
    for year in (2023,2024,2025):
        d=DATA[str(year)]
        if year!=2023:
            build_pdf(year,'Questions',d['questions'],ROOT/'Questions'/f'STATS506_F{str(year)[-2:]}_Midterm_Questions.pdf')
            (ROOT/'Editable sources'/f'STATS506_F{str(year)[-2:]}_Midterm_Questions.md').write_text(md_blocks(d['questions'],f'STATS 506 F{str(year)[-2:]} Midterm - Questions'))
        build_pdf(year,'Answers',d['answers'],ROOT/'Answers'/f'STATS506_F{str(year)[-2:]}_Midterm_Answers.pdf')
        (ROOT/'Answers'/f'STATS506_F{str(year)[-2:]}_Midterm_Answers.md').write_text(md_blocks(d['answers'],f'STATS 506 F{str(year)[-2:]} Midterm - Answer Key'))
    print('Built question/answer PDFs and editable Markdown sources.')
if __name__=='__main__':main()
