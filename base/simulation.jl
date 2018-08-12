include("world.jl")


mutable struct Model
	world :: World
	people :: Vector{Agent}
	migrants :: Vector{Agent}
	network
	knowledge
end


function decide_move(agent :: Agent)
	l = agent.loc
	
end


function simulate!(model :: Model, steps)
	for in in 1:steps
		step_simulation!(model)
	end
end


function step_simulation!(model::Model)
	handle_departures!(model)

	for a in model.migrants
		step_agent!(a, model)
	end

	handle_arrivals!(model)

	spread_information!(model)
end


function spread_information!(model::Model)
	# needed?
end


# *** agent simulation


function step_agent!(agent :: Agent, model::Model)
	if decide_stay(agent)
		step_agent_stay!(agent, model.world)
	else
		step_agent_move!(agent, model.world)
	end

	step_agent_info!(agent, model)
end


function step_agent_move!(agent, world)
	loc_old = agent.loc
	loc = decide_move(agent)
	costs_move!(agent, loc)
	move!(world, agent, loc...)
end


function step_agent_stay!(agent, world)
	costs_stay!(agent)
	explore!(agent)
	mingle!(agent)
	learn!(agent)
end


function step_agent_info!(agent, model)
# spread info to other agent/public
end


# *** entry/exit


function handle_departures!(model::World)
# regularly add new agents
end


function handle_arrivals!(model::World)
# remove arrived agents
end


include("init.jl")
