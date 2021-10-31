import random

People = ['John','Steve','Blake','Chris','Dave','Daniel','Andrew','Adam','Simon','Tim','George']
Team1 = []
Team2 = []
Team3 = []

#Team 1
for x in range(3):
	count = len(People)
	y = random.randrange(0, count)
	Team1.append(People[y])
	People.remove(People[y])

#Team 2
for x in range(4):
	count = len(People)
	y = random.randrange(0, count)
	Team2.append(People[y])
	People.remove(People[y])

#Team 3
for x in range(4):
	count = len(People)
	y = random.randrange(0, count)
	Team3.append(People[y])
	People.remove(People[y])

print(Team1)
print(Team2)
print(Team3)
