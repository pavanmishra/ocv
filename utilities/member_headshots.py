'''
final, urllib2 is used to collect the images of mps
'''
import urllib2
start_with = 540
end_with = 4573

for mp_no in xrange(start_with, end_with):
	print 'trying to collect the image for ', mp_no
	try:
		response = urllib2.urlopen("http://164.100.24.208/ls/lsmember/13biodata/" + str(mp_no) + ".jpg")
		file('public/headshots/new/'+str(mp_no)+'.jpg', 'w').write(response.read())
		print 'Collected new headshot'
	except urllib2.HTTPError:
		try:
			response = urllib2.urlopen("http://164.100.47.132/LssNew/biodata_1_12/"+ str(mp_no) +".gif")
			file('public/headshots/old/'+str(mp_no)+'.gif', 'w').write(response.read())
			print 'Collected old headshots'
		except urllib2.HTTPError:
			file('public/headshots/none/'+str(mp_no)+'.gif', 'w').write('Blah')
			print 'No headshots for mp'