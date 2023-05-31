window.onload = function() {
 
    const svgCanvas = d3.select("svg")
        .attr("width", 960)
        .attr("height", 540)
        .attr("class", "svgCanvas");

    svgCanvas.append("rect")
        .attr("x", 100)
        .attr("y", 100)
        .attr("width", 100)
        .attr("height", 50)
        .attr("rx", 15)
        .attr("ry", 10)
        .attr("fill", "lightblue");
    
        svgCanvas.append("circle")
        .attr("cx", 300)
        .attr("cy", 200)
        .attr("r", 30)
        .attr("fill", "lightgreen");

    svgCanvas.append("ellipse")
        .attr("cx", 300)
        .attr("cy", 400)
        .attr("rx", 30)
        .attr("ry", 60)
        .attr("fill", "lightgreen");

    svgCanvas.append("line")
        .attr("x1", 300)
        .attr("y1", 400)
        .attr("x2", 300)
        .attr("y2", 200)
        .attr("stroke", "black");

}
