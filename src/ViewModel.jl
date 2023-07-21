<#========================================================================================#
"""
ViewModel

Model of all the graphical functionality for the GasTutorial simulation.

Authors: HSWT/AI Simulation Development Group, 20/6/2023.
"""

module ViewModel

include("AgentTools.jl")
include("PhysicalModel.jl")
#using Agents, LinearAlgebra, GLMakie, InteractiveDynamics, Observables
using Agents, LinearAlgebra, InteractiveDynamics, Observables

export set_slider, add_or_remove_agents!, create_custom_slider
const non_id = -1
#----------------------------------------------------------------------------------------
"""
    set_slider( value, slider, slider_value, unit)

Set the value of a slider and its corresponding text.
"""
function set_slider(value, slider, slider_value, unit)
    slider_value.text[] = string(round(value, digits=2), " ", unit) # set text
    set_close_to!(slider, round(value, digits=2)) # set slider
end

#----------------------------------------------------------------------------------------
"""
    add_or_remove_agents!(model)

Handle the number of particles in the simulation based on n_particles.
"""
function add_or_remove_agents!(model)
    if model.n_particles > model.n_particles_old # if n_particles is increased
        scaled_speed = PhysicalModel.calc_and_scale_speed(model)
        for _ in 1:(model.n_particles - model.n_particles_old) # add the difference
            vel = Tuple( 2rand(2).-1) # random velocity vector
            vel = vel ./ norm(vel) # normalize velocity vector
            add_agent!(model, vel, model.mass_kg, scaled_speed, model.radius, non_id, -Inf)
        end

        model.n_particles_old = model.n_particles

    elseif model.n_particles < model.n_particles_old # if n_particles is decreased

            for _ in 1:(model.n_particles_old - model.n_particles) # remove the difference
                if nagents(model) > 0
                    agent = random_agent(model) # get a random agent
                    kill_agent!(agent, model) # kill it
                end
            end
        model.n_particles_old = model.n_particles
    end
end

#----------------------------------------------------------------------------------------
"""
    create_custom_slider(gl_sliders, row_num, labeltext, fontsize, range, unit, startvalue)

Create a custom slider with a label and a value label.
"""
function create_custom_slider(gl_sliders, row_num, labeltext, fontsize, range, unit, startvalue)
    label = Label(gl_sliders[row_num, 0], labeltext, fontsize=fontsize) # create label
    slider = Slider(gl_sliders[row_num, 1], range=range, startvalue=startvalue) # create slider
    slider_value = Label(gl_sliders[row_num, 2], string(round(slider.value[], digits=2)) * " " * unit) # create value label
    return label, slider, slider_value
end

end 