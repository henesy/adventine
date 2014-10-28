#!/usr/bin/env ruby
# chmod +x ./adventineII2.0.rb
# Maybe add our own packaged version of ruby?
#require "./adv2rooms.rb"  #classes are cool
#
# Expansions can be added through:
# require "/path/to/expansion.rb"
#
### Written by Sean Hinchee
#
#
# v2.2.4
# 2.2.0: north room, basic dialogue
# 2.2.1: all 1g rooms, medium dialogue
# 2.2.2: user creation dialogue (kinda)
# 2.2.3: added stuff for use + combat + inventory + stats; +EFE
# 2.2.4: added class dialogue (expanded)
# 2.2.5: added COLORS!!!!!
#
# ----------Braining----------
# Rooms: Cavern, South Wall, Intersection, East Forest Edge
#
# Ideas: item dropping, static objects in general
# • implementing a real class structure (working on that)
# • word processing (hah)
# • class dynamics of some sort (working on that)
# • interactive items
# • limited inventory (use `each` loops)
# • color code output!
#

$room = "Cavern"
$fudged = 0
$points = 5
$points_spent = 0
$points_total = 5 #points...?
$sneakstate = 0
$tate = 1
$userprofile = {'name' => 'none', 'state' => $tate, 'class' => $pclass}
# just a note, hashes are defined with {} and called with []  :)
$stats = {'damage_bonus' => 0, 'luck' => 0, 'mana' => 0, 'defense_bonus' => 0} #hashes fuck yeah
# classes:
# Warrior, Thief, Wizard
$inventory = {} #more..hashes? maybe? sleep on this one
$fresh = 0
$pclass = ""
$engaged = 0

#enemies block  # use $enemies.sample
$enemies = [10] # need match-based enemy processing
$enemies[0] = "Bear"
$enemies[1] = "Wolf"
$enemies[2] = "Will" #integrate
$enemies[3] = ""
$enemies[4] = ""
$enemies[5] = "Rabbit"
$enemies[6] = "Donkey"
$enemies[7] = "Friday Tests"
$enemies[8] = "Rabid Squirrel"
$enemies[9] = "Grue"

#loot block
$madloot = [10]
$madloot[0] = "Gold Necklace"
$madloot[1] = "Silver Ring"
$madloot[3] = "Diamond"
$madloot[4] = "Gold Nugget"
$madloot[5] = "Sapphire"
$madloot[6] = "Uranium (235)"
$madloot[7] = "Pearl"
$madloot[8] = "Emerald"
$madloot[9] = "Ruby"

$ididitagain = 0 # :P

def classprocessing(choice)
	classname = $pclass #(make this global?)
	if choice == 1 #lotsa dialogue
		if $fudged == 0
		puts "Greetings #{$userprofile['name']}...choose your stats..."
		else
		end
		puts "You have a total of #{$points} to spend:"

		print "Strength: "
		dmg = $stdin.gets.chomp.to_i
		print "Luck: "
		lck = $stdin.gets.chomp.to_i
		print "Mana: "
		mna = $stdin.gets.chomp.to_i
		print "Resilience: "
		dfs = $stdin.gets.chomp.to_i
		dmg + lck + mna + dfs = $points_spent
		if $points_spent < $points_total && $points_spent > $points_total
			puts "Whoops, that didn't add up, try again..."
			$fudged = 1
			classprocessing(1)
		else
			puts "\nSo your stats are:" #each loop? #naw
			puts "Strenth: #{dmg}"
			puts "Luck: #{lck}"
			puts "Mana: #{mna}"
			puts "Resilience: #{dfs}"
			puts "\n"
			#puts ""
			print "Are these the stats you want? [y/n]: "
			queryk = $stdin.gets.chomp.downcase
			if queryk == "y"
				puts "Okay then!"
				puts "\n"
			elsif queryk == "yes"
				puts "Okay then!"
				puts "\n"
			else
				puts "Alright,let's reset your stats..."
				puts ""
				$fudged = 1
				classprocessing(1)
			end
		end
	else
		print ""
	end
	pclass = $pclass
	if pclass  == 1 #warrior
		$stats['damage_bonus'] = 1
		$stats['luck'] = 0
		$stats['mana'] = 0
		$stats['defense_bonus'] = 2
	elsif pclass == 2 #thief
		$stats['damage_bonus'] = 1
		$stats['luck'] = 2
		$stats['mana'] = 0
		$stats['defense_bonus'] = 0
	elsif pclass == 3 #wizard
		$stats['damage_bonus'] = 0
		$stats['luck'] = 0
		$stats['mana'] = 3
		$stats['defense_bonus'] = 0
	end
end

def newuser() # user creation  #REWRITE AND PROCESS FFS # I DID IT
	system 'clear'
	if $ididitagain == 0
		puts "\e[33m Welcome to the world of\e[34m Adventine!\e[37m" #colors!
	else
	end
	print "What is your name?: "
	$userprofile['name'] = $stdin.gets.chomp.downcase
	puts "You must now select a class... " # class selection etc
	print """
	[1] Warrior
	[2] Thief
	[3] Wizard
	"""
	print "Class Selection: "
	newclassthing = $stdin.gets.chomp.to_i
	if newclassthing < 4 && newclassthing > 0
		$pclass = newclassthing #stahf
		print "Do you want to choose your stats? [y/n]: " ""
		resultm = $stdin.gets.chomp.downcase
		if resultm == "yes"
			resultm = "y" #useless now
			classprocessing(1)
		elsif resultm == "y"
			classprocessing(1)
		else
			classprocessing(0)
		end
		classprocessing($pclass)
	else
		puts "Let's try this again...\n"
		maybeidid = 1
		$ididitagain = maybeidid
		newuser()
	end
	#$pclass = newclassthing #depreceated
end

def sneaking()
	if $sneakstate == 0
		$sneakstate = 1
	elsif $sneakstate == 1
		$sneakstate = 0
	else
		print ""
	end
end

def combatdialogue() #combatdialogue() is called by combat.dialogue
					 #which is called by processing.test
					 ## SYNC WITH COMBAT CLASS WTF?!?!!?!
					 ### recursive calls are so stupid
	print """
	[0] Do nothing
	[1] Assault
	[2] Taunt
	[3]	Dodge
	[4] Run Away
	"""
	print "\n: "
	input = $stdin.gets.chomp
	return input
end

def helpwords()  ### add `inventory` and `class`
	puts """
	help - show this list
	inventory - show inventory
	class - show class details
	north - move north
	east - move east
	south - move south
	west - move west
	attack - attack dialogue
	sneak - enter sneak mode
	use - utilize item
	quit - leave game
	"""
end


def quitdialogue()
	print "Are you sure you want to quit?[y/n]: "
	input = $stdin.gets.chomp.downcase
	if input == "y"
	print "\e[0m"
	exit(0)
	else
	puts ""
	end
end

def prompt()
	@processing = Processing.new()
	print "\e[31m\n\"#{$room}\"\e[92m>\e[36m "
	input = $stdin.gets.chomp.downcase
#	input2 = input.split  #nope.
	@processing.test(input)
	print "\e[37m" #default reset?
	return input
end

class Creeps #the beasties

	def bear
	end

	def wolf
		puts "A wolf suddenly appears!"
		newthing = combatdialogue()
	end

	def will
	end

	def rabbit
	end

	def donkey
	end

	def fridaytests
	end

	def rabidsquirrel
	end

	def grue
	end

end

class MadLoot
end

class Use  #inventory processing
	def prompt
	@usage = Use.new()
	print "From Inventory [1]\nIn Room [2]\n\n: "
	answer = $stdin.gets.chomp.to_i
	if answer > 0 && answer < 3
		if answer == 2
		@usage.room
		else
		@usage.inventory
		end
	else
	puts "Um, Where?"
	@usage.prompt()
	end #if end
	end #def end

	def inventory # yeah we do things here
	end

	def room # room...specifics? case structures? ew....
	end
end

class Room
	def initialize()  #run at .new() #unnecessary
#		@initiated = initiated
		@processing = Processing.new()
	end

	def move(mover) #### new room state? simplification w/ processor?
		roomtb = mover
		mroom = Room.new()
		if $engaged != 0
			roomtb = "sweetie bot"
		else
		end
		case roomtb
		when "Intersection"
			mroom.northlight()
		when "Cavern"
			mroom.firstroom()
		when "South Wall"
			mroom.southwall()
		when "Darkness"
			mroom.darkness()
		else
		puts "You can't move there!"
		roombleh = $room
		case roombleh
		when "Cavern"
		mroom.firstroom()
		when "Intersection"
		mroom.northlight()
		when "South Wall"
		mroom.southwall()
		else
		prompt()
		end # case end
		end
		#roomnow = $room
		#mroom = Room.new()
		#input = mover

		#case roomnow #case to decide movement
		#when "Cavern"
			#if input == "north"
				#room = mroom.newroom("Intersection")
				#mroom.northlight
			#elsif input == "south"
				#room = mroom.newroom("South Wall")
				#mroom.southwall
			#elsif input == "west"
				#room = mroom.darkness()
			#elsif input == "east"
				#room = mroom.darkness()
			#else
			#end
		#when "Intersection"
		#puts ""
		#when "South Wall"
		#puts ""
		#else
		#puts "You find yourself unable to move!!!"
		#end


	end

	def newroom(roomnew)
		@roomstate = roomnew
		$room = @roomstate # words are so hard
	end

	def firstroom()
		$room = "Cavern"
		mroom = Room.new()  #short for ManageRoom
		puts "You are in a cold cavern"
		puts "There is a dim light shining from the north"
		puts "There is a chilly breeze from the west"
		puts "There is darkness to the east"
		puts "A wall lies to the south"
		puts ""
		input = prompt()
		mroom.move(input)
		#if input == "north"
		#	room = mroom.newroom("Intersection")
		#	mroom.northlight
		#elsif input == "south"
		#	room = mroom.newroom("South Wall")
		#	mroom.southwall
		#elsif input == "west"
		#	room = mroom.darkness()
		#elsif input == "east"
		#	room = mroom.darkness()
		#else
		#end
	end

	def darkness()
		puts "You feel your body grow colder and colder..."
		puts "Darkness overtakes you"
		puts """
		                   ---Game Over---
		"""
		print "Try again? [y/n]"
		input = prompt()
		if input == "y"
		start()
		$fresh = 0
		else
		exit(0)
		end
	end

	def northlight()
		$room = "Intersection"
		puts "Warmth flows through your body"
		puts "A small house is visible to the north"
		puts "Roads lead both west and east"
		input = prompt()
	end

	def southwall()
		$room = "South Wall"
		puts "As you look closely at the wall you notice"
		puts "a small hairline crack runs from the ceiling to the floor"
		#puts "the floor"
		input = prompt()
		# need to do command stuff here "help"
		#@processing.test(input)  # test for "help"
	end

	def eastforestedge() # interact with wolf! :DD
						 ## DAMMIT I HAVE TO UPDATE EVERYTHING
	end
end

class Processing #write .test
	def test(words) #edit
		@combat = Combat.new()
		@mroom = Room.new()
		@muse = Use.new()
		toreturn = ""
		myroom = $room
		if words == "n" #to change "n" to "north"
			words = "north"
		elsif words == "s"
			words = "south"
		elsif words == "e"
			words = "east"
		elsif words == "w"
			words = "west"
		elsif words == "q"
			words = "quit"
		else
		print ""
		end
		case words #directionals handled inside room fxns
			when "help"
			helpwords()
			when "quit"
			quitdialogue()
			when "attack"
			@combat.dialogue()
			when "sneak"
			sneaking()
			when "use"
			@muse.prompt()
			when "y"
			print ""
			#when "n"
			#print ""
			when "north" #or "n"
				case myroom
				when "Cavern"
				@mroom.move("Intersection")
				when "Intersection"
				@mroom.move("")
				when "South Room"
				@mroom.move("Cavern")
				end
			when "south" #or "s"
				case myroom
				when "Intersection"
				@mroom.move("Cavern")
				when "Cavern"
				@mroom.move("South Wall")
				end
			when "east" #or "e"
				case myroom
				when "Cavern"
				@mroom.move("Darkness")
				when "Intersection"
				@mroom.move("")
				when "South Wall"
				@mroom.move("")
				end
			when "west" #or "w"
				case myroom
				when "Cavern"
				@mroom.move("Darkness")
				end
			else
			puts "\npardon me?\n\n" #need to catch and restart room
				case myroom
				when "Cavern"
				@mroom.firstroom()
				when "Intersection"
				@mroom.northlight()
				when "South Wall"
				@mroom.southwall()
				else
				puts "\npardon me?\n\n"
				end
		end # case end
	return toreturn
	end # test() end
end

#class Combat  #derp
#end

class Combat  #check combatdialogue
	#def initialize #definitions for class vars  #makeitstop
	#@fdbk = Combat.new()
	#end

	def dialogue
		howdoi = $room
		@creepz = Creeps.new()
		case howdoi
		when "Cavern"
		puts "There's nothing to fight\n"
		when "South Wall"
		when "Intersection"
		when "East Forest Edge"
		@creepz.wolf()
		end
	end

	def engage(maybething)  ## add class `command`
		if maybething == 1
		elsif maybething == 2
		elsif maybething == 3
		elsif maybething == 4
		else
		print "" #ON PURPOSE SHOOT A BLANK
		#@fdbk.engage()  #no...?
		end
		@fdbk = Combat.new()
		puts "How do you want to react?"
		print """
		[1] Bravely Flee!
		[2] Talk to it...
		[3] Engage it!
		[4] (Class Ability)
		"""
		print ": "
		@fdbk.feedback()
	end
	def feedback
			thingy = $stdin.gets.chomp
			#@fdbk = Combat.new()
			#if thingy == 1 || 2 || 3 || 4 # OH GOD YOU HAVE TO REDO IT
			# look at how sexy that fix is
			if thing < 5 && thing > 0
			@fdbk.engage(thingy)
			else
			print "Try a real option: "
			spare = 0
			@fdbk.engage(spare)
			end
	end

	def flee
	end

	def talk
	end

	def fight
	end

	def cspecial
	end

	#def creepp #creep processing
	#end

	def randcreep
		cotm = $enemies.sample #array goodness
		@creepz = Creeps.new()
		case cotm # from index
		when "Bear"
		@creepz.bear()
		when "Wolf"
		@creepz.wolf()
		#when ""
		#when ""
		#when ""
		when "Rabbit"
		@creepz.rabbit()
		when "Donkey"
		@creepz.donkey()
		when "Friday Tests"
		@creepz.fridaytests()
		when "Rabid Squirrel"
		@creepz.rabidsquirrel()
		when "Grue"
		@creepz.grue()
		#else
		#puts "hurro"
		end
	end
	#input = prompt() #depreated for combat
	# hashes for enemies?
end # def end
#end #class end

def start ()
	mroom = Room.new()  #short for ManageRoom
	if $fresh == 0
	newuser()
	else
	print ""
	end
	while $tate == 1
		room = $room
		case room
		when "Cavern"
		mroom.firstroom
		when "Intersection"
		mroom.northlight
		when "South Wall"
		mroom.southwall
		else
		prompt()
		end # case end

	end #while end
end #start end

start()
