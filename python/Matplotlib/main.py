# Matplotlib is a low level graph plotting library in python that serves as a visualization utility.

# Matplotlib was created by John D. Hunter.

# Matplotlib is open source and we can use it freely.

# Matplotlib is mostly written in python, a few segments are written in C, Objective-C and Javascript for Platform compatibility.



import matplotlib
import matplotlib.pyplot as plt
import numpy as np

print(matplotlib.__version__)


# Pyplot

# Most of the Matplotlib utilities lies under the pyplot submodule, and are usually imported under the plt alias:

# Now the Pyplot package can be referred to as plt.

# Draw a line in a diagram from position (0,0) to position (6,250):

# xpoints = np.array([0, 6])
# ypoints = np.array([0, 250])

# plt.plot(xpoints, ypoints)
# plt.show()

# You will learn more about drawing (plotting) in the next chapters.


# Matplotlib Plotting

# Plotting x and y points
# The plot() function is used to draw points (markers) in a diagram.

# By default, the plot() function draws a line from point to point.

# The function takes parameters for specifying points in the diagram.

# Parameter 1 is an array containing the points on the x-axis.

# Parameter 2 is an array containing the points on the y-axis.

# If we need to plot a line from (1, 3) to (8, 10), we have to pass two arrays [1, 8] and [3, 10] to the plot function.

# Draw a line in a diagram from position (1, 3) to position (8, 10):


# xpoints = np.array([1, 2, 6, 8])
# ypoints = np.array([3, 8, 1, 10])

# plt.plot(xpoints, ypoints, 'd-.r', ms = 20)
# plt.show()

# y1 = np.array([3, 8, 1, 10])
# y2 = np.array([6, 2, 7, 11])

# plt.plot(y1)
# plt.plot(y2)

# plt.show()


# Plotting Without Line

# To plot only the markers, you can use shortcut string notation parameter 'o', which means 'rings'.



# Matplotlib Labels and Title

# Create Labels for a Plot
# With Pyplot, you can use the xlabel() and ylabel() functions to set a label for the x- and y-axis.
# x = np.array([80, 85, 90, 95, 100, 105, 110, 115, 120, 125])
# y = np.array([240, 250, 260, 270, 280, 290, 300, 310, 320, 330])

# plt.plot(x, y)

# font1 = {'family':'serif','color':'blue','size':20}
# font2 = {'family':'serif','color':'darkred','size':15}

# plt.title("Sports Watch Data", fontdict = font1, loc = 'left')
# plt.xlabel("Average Pulse", fontdict = font2)
# plt.ylabel("Calorie Burnage", fontdict = font2)

# plt.show()




# Matplotlib Adding Grid Lines


# Add Grid Lines to a Plot
# With Pyplot, you can use the grid() function to add grid lines to the plot.

# x = np.array([80, 85, 90, 95, 100, 105, 110, 115, 120, 125])
# y = np.array([240, 250, 260, 270, 280, 290, 300, 310, 320, 330])

# plt.title("Sports Watch Data")
# plt.xlabel("Average Pulse")
# plt.ylabel("Calorie Burnage")

# plt.plot(x, y)

# # plt.grid(axis = 'x')
# plt.grid(color = 'green', linestyle = '--', linewidth = 0.5)


# plt.show()



# Matplotlib Subplot
# Display Multiple Plots
# With the subplot() function you can draw multiple plots in one figure:
#plot 1:
# x = np.array([0, 1, 2, 3])
# y = np.array([3, 8, 1, 10])

# plt.subplot(1, 2, 1)
# plt.plot(x,y)

# #plot 2:
# x = np.array([0, 1, 2, 3])
# y = np.array([10, 20, 30, 40])

# plt.subplot(1, 2, 2)
# plt.plot(x,y)

# plt.show()



#plot 1:
# x = np.array([0, 1, 2, 3])
# y = np.array([3, 8, 1, 10])

# plt.subplot(2, 1, 1)
# plt.plot(x,y)

# #plot 2:
# x = np.array([0, 1, 2, 3])
# y = np.array([10, 20, 30, 40])

# plt.subplot(2, 1, 2)
# plt.plot(x,y)

# plt.show()


# x = np.array([0, 1, 2, 3])
# y = np.array([3, 8, 1, 10])

# plt.subplot(2, 3, 1)
# plt.plot(x,y)

# x = np.array([0, 1, 2, 3])
# y = np.array([10, 20, 30, 40])

# plt.subplot(2, 3, 2)
# plt.plot(x,y)

# x = np.array([0, 1, 2, 3])
# y = np.array([3, 8, 1, 10])

# plt.subplot(2, 3, 3)
# plt.plot(x,y)

# x = np.array([0, 1, 2, 3])
# y = np.array([10, 20, 30, 40])

# plt.subplot(2, 3, 4)
# plt.plot(x,y)

# x = np.array([0, 1, 2, 3])
# y = np.array([3, 8, 1, 10])

# plt.subplot(2, 3, 5)
# plt.plot(x,y)

# x = np.array([0, 1, 2, 3])
# y = np.array([10, 20, 30, 40])

# plt.subplot(2, 3, 6)
# plt.plot(x,y)

# plt.show()

#plot 1:
x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])

plt.subplot(1, 2, 1)
plt.plot(x,y)
plt.title("SALES")

#plot 2:
x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])

plt.subplot(1, 2, 2)
plt.plot(x,y)
plt.title("INCOME")

plt.suptitle("MY SHOP")
plt.show()