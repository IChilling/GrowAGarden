-- This Script Automatically Starts The Mutation Machine

-- Allows you to start the Mutation Machine early, so then later on you can simply put a pet in and it will be ready to collect, as long as an hour has passed

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local PetMutationMachineService_RE = GameEvents:WaitForChild("PetMutationMachineService_RE")

local NPCs = game.Workspace:WaitForChild("NPCS")
local PetMutationMachine = NPCs:WaitForChild("PetMutationMachine")
local PetMutationMachineModel = PetMutationMachine:WaitForChild("Model")
local ProxPromptPart = PetMutationMachineModel:WaitForChild("ProxPromptPart")
local PetMutationMachineProximityPrompt = ProxPromptPart:WaitForChild("PetMutationMachineProximityPrompt")

-- The first part is firing the remote event to start the machine
local function StartMutationMachine()
    PetMutationMachineService_RE:FireServer(
        "StartMachine"
    )
end

-- Then they use a proximity prompt to handle the payment
local function InteractWithMachinePrompt()
    fireproximityprompt(PetMutationMachineProximityPrompt)
end

StartMutationMachine()

task.wait()

InteractWithMachinePrompt()
