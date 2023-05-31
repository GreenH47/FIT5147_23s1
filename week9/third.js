window.onload = function() {
 
    const svgCanvas = d3.select("svg")
        .attr("width", 960)
        .attr("height", 540)
        .attr("class", "svgCanvas");
 
    d3.csv("third.csv").then(function(d) {
        console.log(d);
 
        let minValue = Infinity;
        let maxValue = -1;
        d.forEach(function(thisD) {
            let thisValue = thisD["value"];
            minValue = Math.min(minValue, thisValue);
            maxValue = Math.max(maxValue, thisValue);
        });
 
        let value2range = d3.scaleLinear()
            .domain([minValue, maxValue])
            .range([0.5, 1]);
 
        let range2color = d3.interpolateBlues;
 
        svgCanvas.selectAll("circle")
            .data(d) // create place holders if the data are new
            .join("circle") // create one circle for each
            .attr("cx", function(thisElement, index) {
                return 150 + index * 150; // calculate the centres of circles
            })
            .attr("cy", 300)
            .attr("r", function(thisElement) {
                return thisElement["value"]; // use the value from data to create the radius
            })
            .attr("fill", function(thisElement) {
                return range2color(value2range(thisElement["value"]));
            })
            .on("mouseover", function() {
                svgCanvas.selectAll("circle")
                    .attr("opacity", 0.5); // grey out all circles
                d3.select(this) // hightlight the on hovering on
                    .attr("opacity", 1);
            })
            .on("mouseout", function() {
                // restore all circles to normal mode
                svgCanvas.selectAll("circle")
                    .attr("opacity", 1);
            });
 
        svgCanvas.selectAll("text")
            .data(d)
            .join("text")
            .attr("x", function(thisElement, index) {
                return 150 + index * 150;
            })
            .attr("y", 300 - 35)
            .attr("text-anchor", "middle")
            .text(function(thisElement) {
                return thisElement["title"] + ": " + thisElement["value"];
            });
    });
}