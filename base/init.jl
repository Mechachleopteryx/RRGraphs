using GeoGraph
using DiamondSquare
using Util

function setup_location!(loc, terrain)
	set_p!(loc, :friction, terrain)
end

# TODO parameterize
function create_landscape(xsize, ysize, nres)
	world = World([Location(nres) for x=1:xsize, y=1:ysize])

	data = fill(0.0, xsize, ysize)
	myrng(r1, r2) = rand() * (r2 - r1) + r1
	diamond_square(data, myrng, wrap=false)

	mima = extrema(data)

	data .= (data .- mima[1]) ./ (mima[2]-mima[1])

	setup_location!.(world.area, data)

	for i in 1:5
		push!(world.entries, floor(Int, rand()*ysize/2 + ysize/4))
	end

	world
end


# TODO parameterize
# arbitrary values for now
function setup_city!(loc)
	set_p!(loc, :friction, 0.2)
	set_p!(loc, :control, 0.8)
	set_p!(loc, :information, 0.8)
end


# TODO parameterize
function setup_link!(loc)
	set_p!(loc, :friction, 0.1)
	set_p!(loc, :control, 0.5)
end


function add_cities!(xsize, ysize, ncities, thresh, nres, world)
	nodes, world.links = create_random_geo_graph(ncities, thresh)
	# rescale to map size
	world.cities = map(x -> (floor(Int, x[1]*(xsize-1) + 1), floor(Int, x[2]*(ysize-1)+1)), nodes)

	# cities
	for (x, y) in world.cities
		setup_city!(world.area[x, y])
	end

	for (i, j) in world.links
		bresenham(world.cities[i]..., world.cities[j]...) do x, y
			setup_link!(world.area[x, y])
		end
	end
end


function create_world(xsize, ysize, ncities, thresh, nres)
	world = create_landscape(xsize, ysize, nres)
	add_cities!(xsize, ysize, ncities, thresh, nres, world)

	world
end
