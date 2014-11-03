#!/usr/bin/env ruby
# chmod +x ./adventineII2.0.rb
# Maybe add our own packaged version of ruby?
#require "./adv2rooms.rb"  #classes are cool
#
# Expansions can be added through:
# require "/path/to/expansion.rb" #modules temporarily removed
#
### Written by Sean Hinchee
### Adventine is a project started and operated by Sean Hinchee
### Adventine was originally created as a programming class project
#
#
# v2.2.7
# 2.2.0: north room, basic dialogue
# 2.2.1: all 1g rooms, medium dialogue
# 2.2.2: user creation dialogue (kinda)
# 2.2.3: added stuff for use + combat + inventory + stats; +EFE
# 2.2.4: added class dialogue (expanded)
# 2.2.5: added COLORS!!!!!
# 2.2.6: bugfixes, cleared up code for moving, minor rebuild of stats
# 2.2.7: bugfixes with movement, added combat basics and loop, overhauled
# the framework for creatures, added creatures and stats and player classes
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
# • levelling/stat increase XP build regular check system?
# • A room class :: rewrite might be in order....
#
# -------- # Begin Global Variables # -------- #

$room = "Cavern"
$fudged = 0
$points = 5
$points_spent = 0
$points_total = 5 #points...?
$sneakstate = 0
$tate = 1
$userprofile = {
	'name' => 'none',
	'state' => $tate,
	'class' => $pclass
	}
# just a note, hashes are defined with {} and called with []  :)
$stats = {
	'damage_bonus' => 0,
	'luck' => 0,
	'mana' => 0,
	'defense_bonus' => 0
	} #hashes fuck yeah
$blank = "sweetie bot"
# classes:
# Warrior, Thief, Wizard
#$inventory = {} #more..hashes? maybe? sleep on this one ##slept on it
$inventory = [20] #must be crawled, therefore: array

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
#--
$estate = { #THIS NEW FORMAT THO
	"Bear" => 1,
	"Wolf" => 1,
	"Will" => 1,
	"" => 1,
	"" => 1,
	"Rabbit" => 1,
	"Donkey" => 1,
	"Friday Tests" => 1,
	"Rabid Squirrel" => 1,
	"Grue" => 1,
}

$east_wolf = 1

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

# -------- # End Global Variables # -------- #

class String #manipulate internal stuffs
	def black;          "\033[30m#{self}\033[0m" end
	def red;            "\033[31m#{self}\033[0m" end
	def green;          "\033[32m#{self}\033[0m" end
	def brown;          "\033[33m#{self}\033[0m" end
	def blue;           "\033[34m#{self}\033[0m" end
	def magenta;        "\033[35m#{self}\033[0m" end
	def cyan;           "\033[36m#{self}\033[0m" end
	def gray;           "\033[37m#{self}\033[0m" end
end

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
		$points_spent = dmg + lck + mna + dfs
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
		puts "\e[33m Welcome to the world of\e[35m Adventine!\e[37m" #colors!
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
		print "Do you want to choose your stats? [y/n]: "
		resultm = $stdin.gets.chomp.downcase
		if resultm == "yes"
			#resultm = "y" #useless now
			classprocessing(1)
		elsif resultm == "y"
			classprocessing(1)
		else
			puts ""
			classprocessing(0)
		end
		#classprocessing($pclass) #wtf?
	else
		puts "Let's try this again...\n"
		maybeidid = 1
		$ididitagain = maybeidid
		newuser()
	end
	#$pclass = newclassthing #depreceated
end

def roll() #dice dice baby
	rand(1..20) #1-20 inclusively
end

class Sneaking

def toggle()
	currentclass = $userprofile['class']
	if $sneakstate == 0
		case $pclass
		when 2
			puts "You slink low to the ground and fade into the shadows..."
		when 1
			puts "You slump your shoulders and bend over, attempting stealth..."
		when 3
			puts "You crouch and begin shuffling along the ground..."
		end
		$sneakstate = 1
	elsif $sneakstate == 1
		puts "You stand up, casting aside any concept of the element of surprise..."
		$sneakstate = 0
	else
		print "Error in \"class Sneaking\""
	end
end

def test(difficulty) #called by mobs
	#benchmarking this is kinda hard, experimental values
	#looking at about a cap of difficulty at 30 or so DnD style
	#making this about +11 at max bonus, which sounds reasonable to me
	case difficulty
	when "Easy"
		thing = roll() + stats['luck'] +6
	when "Medium"
		thing = roll() + stats['luck'] +2
	when "Hard"
		thing = roll() +stats['luck'] +0
	end
	return thing
end

end #class end

def combatdialogue() #combatdialogue() is called by combat.dialogue
					 #which is called by processing.test
					 ## SYNC WITH COMBAT CLASS WTF?!?!!?!
					 ### recursive calls are so stupid
	print """
	[0] Do nothing
	[1] Assault
	[2] Taunt
	[3] Dodge
	[4] Run Away
	"""
	print "\n: "
	input = $stdin.gets.chomp.to_i #fix this cause letters
	if input > -1 && input <5
		return input
	else
		puts "That's not an option."
		combatdialogue()
	end
	#return input
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
	print "Are you sure you want to quit? [y/n]: "
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

# -------- # End Global Def's / Begin Classes # -------- #

class Inventory

	def dialogue
		invent = Inventory.new()
		print "Do you want to view your inventory? [y/n]: "
		resp = $stdin.gets.chomp.downcase
		if resp == "yes"
			invent.show()
		elsif resp == "y"
			invent.show()
		else
			prompt()
		end
	end

	def show
		puts "+----------------+"
		items = $inventory
		items.each do |n|
			puts "| "
		end
	end

	def update
	end

	def check #save this for inventory check calls
	end

end

class Creeps #the beasties

#cased initialize + case?
	def initialize(mob)
		#@creepz = Creeps.new("") ## OOPS
		#@dummy = "meep"
		case mob
		when "Wolf"
					@currentmob = "Wolf"
					@hp = 5
					@dfs = 1
					@atk = 1
					@mna = 0
					@lck = 0
		when "Bear"
			@currentmob = "Bear"
		when "Will"
			@currentmob = "Will"
		when "Rabbit"
			@currentmob = "Rabbit"
		when "Donkey"
			@currentmob = "Donkey"
		when "Friday Tests"
			@currentmob = "Friday Tests"
		when "Rabid Squirrel"
			@currentmob = "Rabid Squirrel"
		when "Grue"
			@currentmob = "Grue"
		else
		end
	end

	def engage(mob) #if and stuff
		# if mob statement here #case *ftfy
		@creepz = Creeps.new($blank)
		case mob #only handles text....
		when "Wolf"
			puts "\nA vicious wolf stands before you menacingly!"
		when "Bear"
		when "Will"
		when "Rabbit"
		end #end case

		@fighting = 1
		@creepz.engage_utility()
		#stop = 0
		#until stop == 1 #UNTIL
		# newthing = combatdialogue()
		# newthing = newthing.to_i
		# if newthing > -1 && newthing < 5
		# 	#return newthing  #moved to respond() ## *think
		# 	@creepz.think(newthing)
		# 	stop =1
		# else
		#end
		end

	def engage_utility() #hotfix ## fixed
		@creepz = Creeps.new($blank)
		newthing = combatdialogue()
		newthing = newthing.to_i
		if newthing > -1 && newthing < 5
			#return newthing  #moved to respond() ## *think
			@creepz.think(newthing)
		else
		engage_utility(newthing)
	end

	end #def .engage(mob) end

	def attack #HOLY COW WE CAN FINALLY DO MATHS AND COMBAT!!!
	end

###
# case @currentmob
# when "Wolf"
# when "Bear"
# when "Will"
# when "Rabbit"
# when "Donkey"
# when "Friday Tests"
# when "Rabid Squirrel"
# when "Grue"
# end
###

def respond(action) # respond - to - action
	case action
	when "Do Nothing" #0
		case @currentmob
		when "Wolf"
			mresponse = Creeps::Wolf.new()
			mresponse.attack()
		when "Bear"
		when "Will"
		when "Rabbit"
		when "Donkey"
		when "Friday Tests"
		when "Rabid Squirrel"
		when "Grue"
		end
	when "Assault" #1
	when "Taunt" #2
	when "Dodge" #3
	when "Run Away" #4
	end #master case end
end #def end

def think(response)
		case @currentmob
		when "Wolf"
			mresponse = Creeps::Wolf.new()
			if response == 0
				mresponse.respond("Do Nothing")
			elsif response == 1
			elsif response == 2
			elsif response == 3
			elsif response == 4
			else
				puts "Error Report: 'In Creeps.think in `when \"Wolf\"`'"
			end
		when "Bear"

		when "Will"

		when "Rabbit"

		when "Donkey"

		when "Friday Tests"

		when "Rabid Squirrel"

		when "Grue"

		else
		end
	end

	def defeated
	case @currentmob
	when "Wolf"
		puts "The wolf keels over, twitches once, then is still..."
		$engaged = 0
		$east_wolf = 0
		$estate['Wolf'] = 0
	end
	end #def end
#end

	class Bear < Creeps
	end

	class Wolf < Creeps
		# def initialize() #migrating to master
		# 		@hp = 5
		# 		@dfs = 1
		# 		@atk = 1
		# 		@mna = 0
		# 		@lck = 0
		# end
		def initialize(mob)
			super(mob)
		end

	end #end of Wolf

	# def wolf() #migrate to class structure with Creeps::wolf.attack
	# 	# standard style init
	# 	hp = 5
	# 	dfs = 1
	# 	atk = 1
	# 	mna = 0
	# 	lck = 0
	# 	#[0] Do nothing #reference
	# 	#[1] Assault
	# 	#[2] Taunt
	# 	#[3]	Dodge
	# 	#[4] Run Away
	# 	puts "A vicious wolf suddenly appears!"
	# 	newthing = combatdialogue()
	# 	case newthing
	# 	when 0
	#
	# 	when 1
	# 	when 2
	# 	when 3
	# 	when 4
	# 	end
	# end

	class Will < Creeps
	end

	class Rabbit < Creeps
	end

	class Donkey < Creeps
	end

	class Fridaytests < Creeps
	end

	class Rabidsquirrel < Creeps
	end

	class Grue < Creeps
	end

end

class MadLoot #one day...
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
		when "East Forest Edge"
			mroom.eastforestedge()
		else
		puts "\nYou can't move there!\n\n"
		roombleh = $room
		case roombleh
		when "Cavern"
		mroom.firstroom()
		when "Intersection"
		mroom.northlight()
		when "South Wall"
		mroom.southwall()
		when "East Forest Edge"
			mroom.eastforestedge()
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
						$room = "East Forest Edge"
						mcreep = Creeps::Wolf.new("Wolf")
						## DAMMIT I HAVE TO UPDATE EVERYTHING
						puts "Tall trees tower over you"
						#puts "#{$estate['Wolf']}" #testing hash format
						if $east_wolf == 1
							#puts "A vicious wolf appears!" #migrated to creeps
							$engaged = 1
							mcreep.engage("Wolf")
						else
						end
						input = prompt() #NEVER FORGETTI

	end
end #class end


class Processing #write .test
	def test(words) #edit
		@combat = Combat.new() #careful...
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
			prompt() #easy peasy
			when "quit"
			quitdialogue()
			when "attack"
			@combat.process() #argh #fixed
			prompt()
			when "sneak"
			#sneaking() #migrated
			sneaking = Sneaking.new()
			sneaking.toggle()
			#puts $sneakstate
			prompt()
			when "use"
			@muse.prompt()
			prompt()
			when "y"
			print ""
			#when "n"
			#print ""
			when "north" #or "n"
				case $room
				when "Cavern"
					@mroom.move("Intersection")
				when "Intersection"
					@mroom.move("")
				when "South Wall"
					@mroom.move("Cavern")
				when "East Forest Edge"
					@mroom.move("")
				end
			when "south" #or "s"
				case $room
				when "Intersection"
					@mroom.move("Cavern")
				when "Cavern"
					@mroom.move("South Wall")
				when "East Forest Edge"
					@mroom.move("")
				when "South Wall"
					@mroom.move("")
				end
			when "east" #or "e"
				case $room
				when "Cavern"
					@mroom.move("Darkness")
				when "Intersection"
					@mroom.move("")
				when "South Wall"
					@mroom.move("")
				when "East Forest Edge"
					@mroom.move("Intersection")
				end
			when "west" #or "w"
				case $room #trying this
				when "Cavern"
					@mroom.move("Darkness")
				when "Intersection"
					@mroom.move("East Forest Edge")
				when "South Wall"
					@mroom.move("")
				when "East Forest Edge"
					@mroom.move("")
				#break
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
				when "East Forest Edge"
				@mroom.eastforestedge()
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
	# this needs a rewrite
	### No seriously, this is a f**king mess

	def process  #all this does is process things, renaming
		howdoi = $room
		#@creepz = Creeps.new("Bloop")
		@wolf = Creeps::Wolf.new("Wolf")
		nothing = "There's nothing to fight\n"
		case howdoi
		when "Cavern"
			puts "#{nothing}"
		when "South Wall"
			puts "#{nothing}"
		when "Intersection"
			puts "#{nothing}"
		when "East Forest Edge"
		@wolf.engage("Wolf")
		end
	end

### ALL OF THIS IS SO BAD BAD BAD BAD BAD BAD BAD BAD BAD
### is this even used?!
####### NO IT IS NOT USED GET RID OF THIS JUNK
	# def engage(maybething)  ## add class `command`
	# 	if maybething == 1
	# 	elsif maybething == 2
	# 	elsif maybething == 3
	# 	elsif maybething == 4
	# 	else
	# 	print "" #ON PURPOSE SHOOT A BLANK
	# 	#@fdbk.engage()  #no...?
	# 	end
	# 	@fdbk = Combat.new("")
	# 	puts "How do you want to react?"
	# 	print """
	# 	[1] Bravely Flee!
	# 	[2] Talk to it...
	# 	[3] Engage it!
	# 	[4] (Class Ability)
	# 	"""
	# 	print ": "
	# 	@fdbk.feedback()
	# end
	# def feedback
	# 		thingy = $stdin.gets.chomp
	# 		#@fdbk = Combat.new()
	# 		#if thingy == 1 || 2 || 3 || 4 # OH GOD YOU HAVE TO REDO IT #DID IT
	# 		# look at how sexy that fix is
	# 		if thing < 5 && thing > 0
	# 		@fdbk.engage(thingy)
	# 		else
	# 		print "Try a real option: "
	# 		spare = 0
	# 		@fdbk.engage(spare)
	# 		end
	# end

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
		@creepz = Creeps.new("")
		@bear = @creepz::Bear.new("Bear")
		@wolf = @creepz::Wolf.new("Wolf")
		@rabbit = @creepz::Rabbit.new("Rabbit")
		@donkey = @creepz::Donkey.new("Donkey")
		@fridaytests = @creepz::Fridaytests.new("Friday Tests")
		@rabidsquirrel = @creepz::Rabidsquirrel.new("Rabid Squirrel")
		@grue = @creepz::Grue.new("Grue")

		case cotm # from index
		when "Bear"
		@bear.engage("Bear")
		when "Wolf"
		@wolf.engage("Wolf")
		#when ""
		#when ""
		#when ""
		when "Rabbit"
		@rabbit.engage("Rabbit")
		when "Donkey"
		@donkey.engage("Donkey")
		when "Friday Tests"
		@fridaytests.engage("Friday Tests")
		when "Rabid Squirrel"
		@rabidsquirrel.engage("Rabid Squirrel")
		when "Grue"
		@grue.engage("Grue")
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
