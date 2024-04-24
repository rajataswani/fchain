// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeedbackSystem {
    // Struct to store feedback details
    struct Feedback {
        address sender; // address of the sender (student)
        string message; // feedback message
        bool resolved; // flag to indicate if feedback is resolved
        string adminResponse; // admin's response to the feedback
    }

    // Mapping to store feedbacks
    mapping(uint256 => Feedback) public feedbacks;
    uint256 public feedbackCount;

    // Array to store IDs of resolved feedbacks eligible for public display
    uint256[] public publicFeedbackIds;

    // Modifier to restrict access to admin only
    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "Only admin can perform this action");
        _;
    }

    address public adminAddress;

    constructor() {
        adminAddress = msg.sender; // Set contract creator as admin
    }

    // Function to submit feedback
    function submitFeedback(string memory _message) public {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback(msg.sender, _message, false, "");
    }

    // Function to mark feedback as resolved by ID
    function resolveFeedback(uint256 _id) public onlyAdmin {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        feedbacks[_id].resolved = true;
    }

    // Function for admin to write a response to the student
    function writeResponse(uint256 _id, string memory _response) public onlyAdmin {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        feedbacks[_id].adminResponse = _response;
    }

    // Function to post resolved feedback onto a public page
    function postResolvedFeedback(uint256 _id) public onlyAdmin {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        require(feedbacks[_id].resolved, "Feedback not resolved");
        publicFeedbackIds.push(_id); // Add the ID to the list of public feedbacks
    }

    // Function to get feedback count
    function getFeedbackCount() public view returns (uint256) {
        return feedbackCount;
    }

    // Function to get feedback details by ID
    function getFeedback(uint256 _id) public view returns (address, string memory, bool, string memory) {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        Feedback memory feedback = feedbacks[_id];
        return (feedback.sender, feedback.message, feedback.resolved, feedback.adminResponse);
    }

    // Function to get IDs of resolved feedbacks eligible for public display
    function getPublicFeedbackIds() public view returns (uint256[] memory) {
        return publicFeedbackIds;
    }

    // Function to get details of resolved feedbacks eligible for public display
    function getPublicFeedbacks() public view returns (Feedback[] memory) {
        Feedback[] memory publicFeedbacks = new Feedback[](publicFeedbackIds.length);
        for (uint256 i = 0; i < publicFeedbackIds.length; i++) {
            uint256 feedbackId = publicFeedbackIds[i];
            publicFeedbacks[i] = feedbacks[feedbackId];
        }
        return publicFeedbacks;
    }
}
