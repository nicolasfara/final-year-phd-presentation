import sys
p='final-year-phd-presentation.typ'
s=open(p).read()
head=s[:s.index('#title-slide()')]+'#title-slide()\n\n= Deployments <deployment>\n\n'
a=s.index('== Choosing a Deployment'); b=s.index('== Learning the Placement'); c=s.index('// == Evaluation')
open('_testA.typ','w').write(head+s[a:b])
open('_testB.typ','w').write(head+s[b:c])
